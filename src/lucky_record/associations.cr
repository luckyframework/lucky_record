module LuckyRecord::Associations
  macro has_many(type_declaration)
    {% assoc_name = type_declaration.var }
    {% model = type_declaration.type %}
    def {{ assoc_name.id }}
      {{ model }}::BaseQuery.new.{{ @type.name.underscore }}_id(id)
    end
  end

  macro belongs_to(type_declaration)
    {% if type_declaration.type.is_a?(Union) %}
      {% model = type_declaration.type.types.first %}
    {% else %}
      {% model = type_declaration.type %}
    {% end %}

    {% assoc_name = type_declaration.var }
    field {{ assoc_name.id }}_id : Int32

    def {{ assoc_name.id }}
      {{ model }}::BaseQuery.new.find({{ assoc_name.id }}_id)
    end
  end
end
