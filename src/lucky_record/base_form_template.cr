class LuckyRecord::BaseFormTemplate
  macro setup(model_type, fields, table_name, primary_key_type)
    class BaseForm < LuckyRecord::Form({{ model_type }})
      macro inherited
        FOREIGN_KEY = "{{ model_type.stringify.underscore.id }}_id"
      end

      def table_name
        :{{ table_name }}
      end

      add_fields({{ fields }})
    end
  end
end
