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
    end
  end

  desc "Daily task to send subscriptions reminder"
  task :send_subscription_reminders => :environment do
    puts "done"
  end
end
