# Callbacks will trigger before and after the `create`, `save`, or `update` method is called on a form.
#
# To define a callback, you assign a method to one of the callback groups:
#
# ```crystal
# class UserForm < User::BaseForm
#   before_create set_token
#   after_create send_welcome_email
#
#   def set_token
#     token.value = # generate token
#   end
#
#   def send_welcome_email(user : User)
#     # send the user a welcome email
#   end
# end
# ```
#
# You'll notice that the example after method takes a `User`. All `after_*` callbacks take the newly saved record. In addition validation happens before all callbacks. If you need to set values before validation, override the `prepare` method on the form.
#
# When a triggering method is called (`save`, `create`, or `update`) the callbacks in each group execute in the order they were defined.
#
# The callback groups are called in the following order. The callbacks are highlighted in **bold**:
#
# * _validation_
# * **before_save**
# * **before_create** / **before_update**
# * _triggering method eg. save, create, or update_
# * **after_save**
# * **after_create** / **after_update**
module LuckyRecord::Callbacks
  macro before_save(method)
    def before_save
      {% if @type.methods.map(&.name).includes?(:before_save.id) %}
        previous_def
      {% end %}

      {{ method.id }}
    end
  end

  macro after_save(method)
    def after_save(object)
      {% if @type.methods.map(&.name).includes?(:after_save.id) %}
        previous_def
      {% end %}

      {{ method.id }}(object)
    end
  end

  macro before_create(method)
    def before_create
      {% if @type.methods.map(&.name).includes?(:before_create.id) %}
        previous_def
      {% end %}

      {{ method.id }}
    end
  end

  macro after_create(method)
    def after_create(object)
      {% if @type.methods.map(&.name).includes?(:after_create.id) %}
        previous_def
      {% end %}

      {{ method.id }}(object)
    end
  end

  macro before_update(method)
    def before_update
      {% if @type.methods.map(&.name).includes?(:before_update.id) %}
        previous_def
      {% end %}

      {{ method.id }}
    end
  end

  macro after_update(method)
    def after_update(object)
      {% if @type.methods.map(&.name).includes?(:after_update.id) %}
        previous_def
      {% end %}

      {{ method.id }}(object)
    end
  end
end
