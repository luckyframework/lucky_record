class EmployeeBox
  getter form

  @form = Employee::BaseForm.new

  def initialize
    name "Humble Employee"
  end

  def self.save
    new.save
  end

  def save
    if form.save
      form.record.not_nil!
    else
      raise "Did not save. Make sure fields are valid"
    end
  end

  macro method_missing(call)
    form.{{ call.name.id }}.value = {{ call.args.first }}
    self
  end
end
