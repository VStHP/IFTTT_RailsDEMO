module ApplicationHelper
  def check_errors(object, name_attribute)
    'has-error' if object.errors.messages[name_attribute].present?
  end

  def show_errors(object, name_attribute)
    messages = object.errors.messages[name_attribute]
    return "#{messages[0]}" if messages.present?
  end
end
