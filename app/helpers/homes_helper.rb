module HomesHelper
  def home_name(home)
    t("buckler.homes.#{home.name}")
  end
end
