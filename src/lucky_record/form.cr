require "./validations"
require "./needy_initializer_and_save_methods"

abstract class LuckyRecord::Form(T)
  include LuckyRecord::Validations
  include LuckyRecord::NeedyInitializerAndSaveMethods
  include LuckyRecord::AllowVirtual

  enum SaveStatus
    Saved
    SaveFailed
    Unperformed
  end

  macro inherited
    @valid : Bool = true
    @save_status = SaveStatus::Unperformed

    @@allowed_param_keys = [] of String
    @@schema_class = T
  end

  property save_status

  @record : T?
  @params : LuckyRecord::Paramable
  getter :record, :params

  abstract def table_name
  abstract def fields

  def form_name
    self.class.name.underscore.gsub("_form", "")
  end

  def errors
    fields.reduce({} of Symbol => Array(String)) do |errors_hash, field|
      if field.errors.empty?
        errors_hash
      else
        errors_hash[field.name] = field.errors
        errors_hash
      end
    end
  end

  def self.save(*args, **named_args, &block)
    {% raise <<-ERROR
      Forms do not have a 'save' method.

      Try this...

        ▸ Use 'create' to create a brand new record.
        ▸ Use 'update' to update an existing record.

      ERROR %}
  end

  macro add_fields(fields)
    FIELDS = {{ fields }}

    private def extract_changes_from_params
      allowed_params.each do |key, value|
        {% for field in fields %}
          set_{{ field[:name] }}_from_param value if key == {{ field[:name].stringify }}
        {% end %}
      end
    end

    {% for field in fields %}
      @_{{ field[:name] }} : LuckyRecord::Field({{ field[:type] }}?)?

      def {{ field[:name] }}
        _{{ field[:name] }}
      end

      def {{ field[:name] }}=(_value)
        \{% raise <<-ERROR
          Can't set a field value with '{{field[:name]}} = '

          Try this...

            ▸ Use '.value' to set the value: '{{field[:name]}}.value = '

          ERROR
          %}
      end

      private def _{{ field[:name] }}
        @_{{ field[:name] }} ||= LuckyRecord::Field({{ field[:type] }}?).new(
          name: :{{ field[:name].id }},
          param: allowed_params["{{ field[:name] }}"]?,
          value: @record.try(&.{{ field[:name] }}),
          form_name: form_name)
      end

      def allowed_params
        new_params = {} of String => String
        @params.nested(form_name).each do |key, value|
          new_params[key] = value
        end
        new_params.select(@@allowed_param_keys)
      end

      def set_{{ field[:name] }}_from_param(value)
        parse_result = {{ field[:type] }}::Lucky.parse(value)
        if parse_result.is_a? LuckyRecord::Type::SuccessfulCast
          {{ field[:name] }}.value = parse_result.value
        else
          {{ field[:name] }}.add_error "is invalid"
        end
      end
    {% end %}

    def fields
      database_fields + virtual_fields
    end

    private def database_fields
      [
        {% for field in fields %}
          {{ field[:name] }},
        {% end %}
      ]
    end

    def required_fields
      Tuple.new(
        {% for field in fields %}
          {% if !field[:nilable] && !field[:autogenerated] %}
            {{ field[:name] }},
          {% end %}
        {% end %}
      )
    end

    def after_prepare
      validate_required *required_fields
    end
  end

  private def ensure_paramable(params)
    if params.is_a? LuckyRecord::Paramable
      params
    else
      LuckyRecord::Params.new(params)
    end
  end

  def valid? : Bool
    prepare
    after_prepare
    fields.all? &.valid?
  end

  abstract def after_prepare

  def saved?
    save_status == SaveStatus::Saved
  end

  def save_failed?
    save_status == SaveStatus::SaveFailed
  end

  macro allow(*field_names)
    {% for field_name in field_names %}
      {% if field_name.is_a?(TypeDeclaration) %}
        {% raise <<-ERROR
          Must use a Symbol or a bare word in 'allow'. Instead, got: #{field_name}

          Try this...

            ▸ allow #{field_name.var}

          ERROR %}
      {% end %}
      {% unless field_name.is_a?(SymbolLiteral) || field_name.is_a?(Call) %}
        {% raise <<-ERROR
          Must use a Symbol or a bare word in 'allow'. Instead, got: #{field_name}

          Try this...

            ▸ Use a bare word (recommended): 'allow name'
            ▸ Use a Symbol: 'allow :name'

          ERROR %}
      {% end %}
      {% if FIELDS.any? { |field| field[:name].id == field_name.id } %}
        def {{ field_name.id }}
          LuckyRecord::AllowedField.new _{{ field_name.id }}
        end

        @@allowed_param_keys << "{{ field_name.id }}"
      {% else %}
        {% raise <<-ERROR
          Can't allow '#{field_name}' because the column has not been defined on the model.

          Try this...

            ▸ Make sure you spelled the column correctly.
            ▸ Add the column to the model if it doesn't exist.
            ▸ Use 'allow_virtual' if you want a field that is not saved to the database.

          ERROR %}
      {% end %}
    {% end %}
  end

  def changes
    _changes = {} of Symbol => String?
    database_fields.each do |field|
      if field.changed?
        _changes[field.name] = if field.value.nil?
                                 nil
                               else
                                 field.value.to_s
                               end
      end
    end
    _changes
  end

  def save : Bool
    if perform_save
      self.save_status = SaveStatus::Saved
      true
    else
      self.save_status = SaveStatus::SaveFailed
      false
    end
  end

  private def perform_save : Bool
    if valid? && changes.any?
      LuckyRecord::Repo.transaction do
        before_save
        insert_or_update
        after_save(record.not_nil!)
        true
      end
    else
      valid? && changes.empty?
    end
  end

  def save! : T
    if save
      record.not_nil!
    else
      raise LuckyRecord::InvalidFormError(typeof(self)).new(form: self)
    end
  end

  def update! : T
    save!
  end

  private def insert_or_update
    if record_id
      update record_id
    else
      insert
    end
  end

  private def record_id
    @record.try &.id
  end

  # Default callbacks
  def prepare; end

  def after_prepare; end

  def before_save; end

  def after_save(_record : T); end

  private def insert : T
    self.created_at.value = Time.utc_now
    self.updated_at.value = Time.utc_now
    @record = LuckyRecord::Repo.run do |db|
      db.query insert_sql.statement, insert_sql.args do |rs|
        @record = @@schema_class.from_rs(rs).first
      end
    end
  end

  private def update(id) : T
    @record = LuckyRecord::Repo.run do |db|
      db.query update_query(id).statement_for_update(changes), update_query(id).args_for_update(changes) do |rs|
        @record = @@schema_class.from_rs(rs).first
      end
    end
  end

  private def update_query(id)
    LuckyRecord::QueryBuilder
      .new(table_name)
      .select(@@schema_class.column_names)
      .where(LuckyRecord::Where::Equal.new(:id, id.to_s))
  end

  private def insert_sql
    LuckyRecord::Insert.new(table_name, changes, @@schema_class.column_names)
  end
end
