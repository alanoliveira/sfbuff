class BucklerCredential < ApplicationRecord
  extend ExpirableAttribute

  class CredentialNotReady < StandardError; end

  expirable_attribute :build_id
  expirable_attribute :auth_cookie
  after_create_commit :refresh_build_id, :refresh_auth_cookie

  def ready?
    [ build_id, auth_cookie ].all?(&:present?)
  end

  def with_client
    yield buckler_client
  rescue BucklerApi::Errors::PageNotFound => e
    expire_build_id!
    raise e
  rescue BucklerApi::Errors::Unauthorized => e
    expire_auth_cookie!
    raise e
  end

  private

  def buckler_client
    raise CredentialNotReady unless ready?
    BucklerApi::Client.new(build_id:, auth_cookie:)
  end
end
