require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :scheduler do
  desc "Daily task to get WCA competitions"
  task :get_wca_competitions => :environment do
    puts "Getting competitions"
    url_params = {
      sort: "-start_date",
      country_iso2: "FR",
      start: "#{2.days.ago.to_date}",
    }
    begin
      comps_response = RestClient.get(wca_api_competitions_url, params: url_params)
      competitions = JSON.parse(comps_response.body)
      competitions.map do |c|
        puts "Importing #{c["name"]}"
        Competition.create_or_update(c)
      end
      puts "Done."
    rescue => err
      puts "Could not get competitions from the WCA, error:"
      puts err
      puts "---"
      puts "Trying to notify the software team."
      NotificationMailer.with(task_name: "get_wca_competitions", error: err).notify_team_of_failed_job.deliver_now
    end
  end

  desc "Daily task to send subscriptions reminder"
  task :send_subscription_reminders => :environment do
    users_to_notify = User.subscription_notification_enabled.select(&:last_subscription).select do |u|
      u.last_subscription.until == 2.days.from_now.to_date
    end
    # FIXME: remove after test
    users_to_notify = User.subscription_notification_enabled
    puts "#{users_to_notify.size} users to notify."
    users_to_notify.each do |u|
      puts u.name
      begin
        NotificationMailer.with(user: u).notify_of_expiring_subscription.deliver_now
      rescue => err
        puts "Could not notify user!"
        NotificationMailer.with(task_name: "send_subscription_reminders", error: err).notify_team_of_failed_job.deliver_now
      end
    end
  end
end
