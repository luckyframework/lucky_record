module LuckyRecord::Associations
  macro has_many(type_declaration)
    {% assoc_name = type_declaration.var }
    {% model = type_declaration.type %}
    def {{ assoc_name.id }}
      {{ model }}::BaseQuery.new.{{ @type.name.underscore }}_id(id)
    end
  end

  macro belongs_to(type_declaration)
    {% assoc_name = type_declaration.var }

    {% if type_declaration.type.is_a?(Union) %}
      {% model = type_declaration.type.types.first %}
      {% nilable = true %}
    {% else %}
      {% model = type_declaration.type %}
      {% nilable = false %}
    {% end %}

    {% if nilable %}
      field {{ assoc_name.id }}_id : Int32?
    {% else %}
      field {{ assoc_name.id }}_id : Int32
    {% end %}

    def {{ assoc_name.id }}
      {{ model }}::BaseQuery.new.find({{ assoc_name.id }}_id)
    end
  end
end
