module LuckyRecord::Associations
  macro has_many(type_declaration)
    {% assoc_name = type_declaration.var %}

    association table_name: :{{ assoc_name }}

    {% model = type_declaration.type %}
    def {{ assoc_name.id }}
      {{ model }}::BaseQuery.new.{{ @type.name.underscore }}_id(id)
    end
  end

  macro has_one(type_declaration, foreign_key = nil)
    {% assoc_name = type_declaration.var %}

    {% if type_declaration.type.is_a?(Union) %}
      {% model = type_declaration.type.types.first %}
      {% nilable = true %}
    {% else %}
      {% model = type_declaration.type %}
      {% nilable = false %}
    {% end %}

    association table_name: :{{ model }}, foreign_key: {{ foreign_key }}

    def {{ assoc_name.id }}
      query = {{ model }}::BaseQuery.new
      {% if foreign_key %}
        query.{{ foreign_key.id }}(id)
      {% else %}
        query.{{ @type.name.underscore }}_id(id)
      {% end %}

      query.first{% if nilable %}?{% end %}
    end
  end

  macro belongs_to(type_declaration)
    {% assoc_name = type_declaration.var %}

    {% if type_declaration.type.is_a?(Union) %}
      {% model = type_declaration.type.types.first %}
      {% nilable = true %}
    {% else %}
      {% model = type_declaration.type %}
      {% nilable = false %}
    {% end %}

    field {{ assoc_name.id }}_id : Int32{% if nilable %}?{% end %}

    association table_name: :{{ model.resolve.constant(:TABLE_NAME).id }}, foreign_key: :id

    def {{ assoc_name.id }}
      {{ assoc_name.id }}_id.try do |value|
        {{ model }}::BaseQuery.new.find(value)
      end
    end
  end
end
