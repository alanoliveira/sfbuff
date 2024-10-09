module DefaultParams
  def set_default_params
    params.merge!(default_params) do |_, a, b|
      a.blank? ? b : a
    end
  end

  def default_params
    {}
  end
end
