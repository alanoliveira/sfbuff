namespace :buckler_credential do
  desc "Schedule jobs to refresh buckler_credential's build_id and auth_cookie"
  task refresh: :environment do
    buckler_credential = BucklerCredential.take
    buckler_credential.refresh_build_id
    buckler_credential.refresh_auth_cookie
  end

  desc "Create buckler_credential"
  task create: :environment do
    next if BucklerCredential.any?
    BucklerCredential.transaction do
      BucklerCredential.lock("FOR UPDATE")
      BucklerCredential.first_or_create!
    end
  end
end
