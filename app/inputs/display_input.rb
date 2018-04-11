class DisplayInput < SimpleForm::Inputs::StringInput
  WRAPPER_OPTIONS = {
    readonly: true,
    class: "form-control-plaintext",
  }.freeze

  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, WRAPPER_OPTIONS)
    template.text_field_tag(attribute_name, object.send(attribute_name), merged_input_options)
  end
end
