# frozen_string_literal: true

module ApplicationHelper
  def semantic_errors(form)
    errors = form.object.errors.full_messages
    return if errors.empty?

    content_tag(:div, class: 'semantic-errors') do
      safe_join(errors.map { |error| content_tag(:div, error) })
    end
  end

  def form_error(form, method)
    error = form.object.errors.messages_for(method)&.to_sentence
    return if error.empty?

    content_tag(:p, error, class: 'form-error')
  end
end
