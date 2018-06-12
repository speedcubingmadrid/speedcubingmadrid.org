class ColorInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    input_options = {
      type: :color,
      value: object.send(attribute_name),
      name: "#{object_name}[#{attribute_name}]",
    }
    template.tag(:input, wrapper_options.merge(input_options))
  end
end
