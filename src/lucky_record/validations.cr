require "./validations/**"

module LuckyRecord::Validations
  private def validate_required(*fields, message = "is required")
    fields.each do |field|
      if field.value.blank?
        field.add_error message
      end
    end
  end

  private def validate_acceptance_of(field : LuckyRecord::Field(Bool), message = "must be accepted")
    if field.value == false
      field.add_error message
    end
  end

  macro validate_confirmation_of(field_name, message = "must match")
    if {{ field_name.id }}.value != {{ field_name.id }}_confirmation.value
      {{ field_name }}.add_error {{ message }}
    end
  end

  private def validate_inclusions_of(field, in allowed_values, message = "is invalid")
    if !allowed_values.includes? field.value
      field.add_error message
    end
  end
end
