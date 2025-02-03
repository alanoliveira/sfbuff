module InputTypesHelper
  def input_type_name(input_type)
    InputType[input_type].name
  end
end
