alert_type = case error_class_name
when "PlayerSynchronizer::PlayerNotFound" then "player_not_found"
when "BucklerApi::UnderMaintenance" then "buckler_under_maintenance"
when "BucklerApi::RateLimitExceeded" then "buckler_rate_limit_exceeded"
else "generic_error"
end

alert(t("alerts.#{alert_type}"), kind: :danger)
