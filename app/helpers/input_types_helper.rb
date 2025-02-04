module InputTypesHelper
  def input_type_name(input_type)
    InputType[input_type].name
  end

  def input_types_options_for_select
    InputType.to_h { [ input_type_name(it), it.id ] }
  end
end
