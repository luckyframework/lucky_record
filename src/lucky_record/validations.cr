require "./validations/**"

module LuckyRecord::Validations
  private def validate_required(*fields, message = "is required")
    fields.each do |field|
      if field.value.blank?
        field.add_error message
      end
    end
  end

<<<<<<< 7c2ae832427e27335175359656ea927ee6717076
  private def validate_acceptance_of(field : AllowedField(Bool?) | Field(Bool?), message = "must be accepted")
=======
  private def validate_acceptance_of(field : AllowedField(Bool) | Field(Bool), message = "must be accepted")
>>>>>>> Run crystal tool format
    if field.value == false
      field.add_error message
    end
  end

  private def validate_confirmation_of(field, with confirmation_field, message = "must match")
    if field.value != confirmation_field.value
      confirmation_field.add_error message
    end
  end

  private def validate_inclusion_of(field, in allowed_values, message = "is invalid")
    if !allowed_values.includes? field.value
      field.add_error message
    end
  end
end
