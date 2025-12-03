require_relative "../../config/environment"

class BucklerApi < Thor
  desc "reload_credentials", "reload buckler credentials if expired"
  option :now, required: false, type: :boolean, default: false
  def reload_credentials
    if options[:now]
      UpdateBucklerCredentialsJob.perform_now
    else
      UpdateBucklerCredentialsJob.perform_later
    end
  end

  desc "schedule_reload_credentials", "schedule a task to reload buckler credentials if expired"
  def reload_credentials
    UpdateBucklerCredentialsJob.perform_later
  end

  desc "set_auth_cookie AUTH_COOKIE", "set buckler_api auth_cookie"
  def set_auth_cookie(auth_cookie)
    AppSetting.buckler_auth_cookie = auth_cookie
  end

  desc "set_build_id BUILD_ID", "set buckler_api build_id"
  def set_build_id(build_id)
    AppSetting.buckler_build_id = build_id
  end
end
