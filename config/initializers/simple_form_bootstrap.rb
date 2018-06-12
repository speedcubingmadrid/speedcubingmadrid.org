# frozen_string_literal: true
SimpleForm.setup do |config|
  config.error_notification_class = 'alert alert-danger'
  config.button_class = 'btn btn-primary'
  config.boolean_label_class = nil
  config.boolean_style = :inline
  config.label_text = lambda { |label, _, _| "#{label}" }

  config.wrappers :vertical_form, tag: 'div', class: 'form-group' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.use :label, class: 'col-form-label' do

    end
    b.use :input, class: 'form-control'
    b.use :error, wrap_with: {tag: 'span', class: 'invalid-feedback'}
    b.use :hint, wrap_with: {tag: 'small', class: 'form-text text-muted'}
  end

  config.wrappers :vertical_file_input, tag: 'div', class: 'form-group' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :readonly

    b.wrapper tag: 'div', class: 'custom-file' do |ba|
      ba.use :input, class: 'custom-file-input'
      ba.use :label, class: 'custom-file-label'
      ba.use :error, wrap_with: {tag: 'span', class: 'invalid-feedback'}
      ba.use :hint, wrap_with: {tag: 'p', class: 'form-text text-muted'}
    end
  end

  config.wrappers :vertical_boolean, tag: 'div', class: 'form-group' do |b|
    b.use :html5
    b.optional :readonly

    b.wrapper tag: 'div', class: 'checkbox' do |ba|
      ba.use :label_input
    end

    b.use :error, wrap_with: {tag: 'span', class: 'invalid-feedback'}
    b.use :hint, wrap_with: {tag: 'p', class: 'form-text text-muted'}
  end

  config.wrappers :vertical_radio_and_checkboxes, tag: 'div', class: 'form-group' do |b|
    b.use :html5
    b.optional :readonly

    b.use :label, class: 'col-form-label'
    b.use :input
    b.use :error, wrap_with: {tag: 'span', class: 'invalid-feedback'}
    b.use :hint, wrap_with: {tag: 'p', class: 'form-text text-muted'}
  end

  config.wrappers :horizontal_form, tag: 'div', class: 'form-group row' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.use :label, class: 'col-md-4 col-form-label'
    b.wrapper tag: 'div', class: 'col-md-8' do |ba|
      ba.use :input, class: 'form-control'
      ba.use :error, wrap_with: {tag: 'span', class: 'invalid-feedback'}
      ba.use :hint, wrap_with: {tag: 'p', class: 'form-text text-muted'}
    end
  end

  config.wrappers :horizontal_file_input, tag: 'div', class: 'form-group row' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :readonly
    b.use :label, class: 'col-md-3 col-form-label'

    b.wrapper tag: 'div', class: 'col-md-9' do |ba|
      ba.use :input
      ba.use :error, wrap_with: {tag: 'span', class: 'invalid-feedback'}
      ba.use :hint, wrap_with: {tag: 'p', class: 'form-text text-muted'}
    end
  end

  config.wrappers :horizontal_boolean, tag: 'div', class: 'form-group row' do |b|
    b.use :html5
    b.optional :readonly

    b.wrapper tag: 'div', class: 'offset-md-3 col-md-9' do |wr|
      wr.wrapper tag: 'div', class: '' do |ba|
        ba.use :label_input
      end

      wr.use :error, wrap_with: {tag: 'span', class: 'invalid-feedback'}
      wr.use :hint, wrap_with: {tag: 'p', class: 'form-text text-muted'}
    end
  end

  config.wrappers :horizontal_radio_and_checkboxes, tag: 'div', class: 'form-group row horizontal-checkbox' do |b|
    b.use :html5
    b.optional :readonly

    b.wrapper tag: 'div', class: 'custom-control custom-checkbox w-100' do |c|
      c.use :input, class: 'custom-control-input'
      c.use :label, class: 'custom-control-label'
      c.use :error, wrap_with: {tag: 'span', class: 'invalid-feedback'}
      c.use :hint, wrap_with: {tag: 'p', class: 'form-text text-muted'}
    end
  end

  config.wrappers :inline_form, tag: 'div', class: 'form-group' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.use :label, class: 'sr-only'
    b.use :input, class: 'form-control'
    b.use :error, wrap_with: {tag: 'span', class: 'invalid-feedback'}
    b.use :hint, wrap_with: {tag: 'p', class: 'form-text text-muted'}
  end

  config.wrappers :multi_select, tag: 'div', class: 'form-group' do |b|
    b.use :html5
    b.optional :readonly

    b.use :label, class: 'col-form-label'
    b.wrapper tag: 'div', class: 'form-inline' do |ba|
      ba.use :input, class: 'form-control'
      ba.use :error, wrap_with: {tag: 'span', class: 'invalid-feedback'}
      ba.use :hint, wrap_with: {tag: 'p', class: 'form-text text-muted'}
    end
  end


  config.default_wrapper = :vertical_form
  config.wrapper_mappings = {
      check_boxes: :horizontal_radio_and_checkboxes,
      radio_buttons: :horizontal_radio_and_checkboxes,
      file: :vertical_file_input,
      boolean: :horizontal_radio_and_checkboxes,
      datetime: :multi_select,
      date: :multi_select,
      time: :multi_select
  }
end

# SimpleForm::ActionViewExtensions::FormHelper.class_eval do
#
#   private
#
#   def simple_form_css_class(record, options)
#     html_options = options[:html]
#     as = options[:as]
#
#     if html_options.key?(:class)
#       html_options[:class]
#     elsif record.is_a?(String) || record.is_a?(Symbol)
#       as || record
#     else
#       form_css_class_from_record(record, as)
#     end
#   end
#
#   def form_css_class_from_record(record, as)
#     classes = []
#
#     record = record.last if record.is_a?(Array)
#     action = record.respond_to?(:persisted?) && record.persisted? ? :edit : :new
#     classes << as ? "#{action}_#{as}" : dom_class(record, action)
#
#     classes << 'was-validated' if record.errors.any?
#
#     classes.join(' ')
#   end
# end

SimpleForm::Inputs::Base.class_eval do
  # We just need the ability to pass a block on the `use` function
  # then we save it on the Leaf class to be able to call it
  def merge_wrapper_options(options, wrapper_options)
    if wrapper_options
      wrapper_options.merge(options) do |key, oldval, newval|
        case key.to_s
          when 'class'
            classes = Array(oldval) + Array(newval)
            classes << 'is-invalid' if has_errors?
            classes
          when 'data', 'aria'
            oldval.merge(newval)
          else
            newval
        end
      end
    else
      options
    end
  end
end
