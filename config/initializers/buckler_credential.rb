Rails.application.config.to_prepare do
  next if !BucklerCredential.table_exists? || BucklerCredential.any?

  BucklerCredential.transaction do
    BucklerCredential.lock("FOR UPDATE")
    BucklerCredential.first_or_create!
  end
end
