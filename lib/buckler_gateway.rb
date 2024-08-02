# frozen_string_literal: true

class BucklerGateway
  def initialize
    credentials = BucklerCredential.fetch
    @api = Buckler.build_api(credentials, { locale: })
  end

  def method_missing(name, *, &)
    @api.public_send(name, *, &)
  rescue Buckler::Client::AccessDeniedError, Buckler::Client::NotFoundError => e
    BucklerCredential.clean
    raise e
  end

  def respond_to_missing?(name, include_private = false)
    @api.respond_to?(name, include_private)
  end

  private

  def locale
    case I18n.locale
    when :ja then 'ja-jp'
    when :'pt-BR' then 'pt-br'
    else 'en'
    end
  end
end
