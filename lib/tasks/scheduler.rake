require "#{Rails.root}/app/helpers/application_helper"
require "#{Rails.root}/lib/gsuite_mailing_lists"
include ApplicationHelper
include GsuiteMailingLists

namespace :scheduler do
  desc "Daily task to sync mailing lists"
  task :sync_groups => :environment do
    sync_job_messages = []
    # Mailing list for the Board
    board_members = User.select(&:board).map(&:ams_email)
    sync_job_messages << GsuiteMailingLists.sync_group("juntadirectiva@speedcubingmadrid.org", board_members)

    # Mailing list for automatic notifications to subscribers
    subscribers_with_notifications = User.subscription_notification_enabled.with_active_subscription.map(&:ams_email)
    sync_job_messages << GsuiteMailingLists.sync_group("notificaciones-socios@speedcubingmadrid.org", subscribers_with_notifications)

    message = "Se ha realizado la sincronización de los grupos.\n"
    if sync_job_messages.empty?
      message += "No fueron necesarios cambios." if sync_job_messages.empty?
    else
      message += sync_job_messages.join("\n")
    end
    NotificationMailer.with(task_name: "sync_groups", message: message).notify_team_of_job_done.deliver_now
  end

  desc "Daily task to get WCA Competitions"
  task :get_wca_competitions => :environment do
    puts "Getting competitions"
    url_params = {
      sort: "-start_date",
      country_iso2: "ES",
      start: "#{2.days.ago.to_date}",
    }
    begin
      comps_response = RestClient.get(wca_api_competitions_url, params: url_params)
      competitions = JSON.parse(comps_response.body)
      competitions.each do |c|
        puts "Importing #{c["name"]}"
        _, comp_obj = Competition.create_or_update(c)
        if Date.parse(c["announced_at"]) == Date.yesterday
          NotificationMailer.with(competition: comp_obj).notify_of_new_competition.deliver_now
        end
      end
      puts "Done."
      if competitions.any?
        names = competitions.map { |c| c["name"] }
        message = "Las competiciones siguientes se han importado con éxito: #{names.join(", ")}."
        NotificationMailer.with(task_name: "get_wca_competitions", message: message).notify_team_of_job_done.deliver_now
      end
    rescue => err
      puts "Could not get competitions from the WCA, error:"
      puts err
      puts "---"
      puts "Trying to notify the administrators."
      NotificationMailer.with(task_name: "get_wca_competitions", error: err).notify_team_of_failed_job.deliver_now
    end
  end

  desc "Daily task to get WCA persons"
  task :get_wca_persons => :environment do
    puts "Getting persons"
    begin
      wca_ids = User.with_active_subscription.map(&:wca_id)
      names = []
      wca_ids.in_groups_of(100, false).each do |wi|
        persons_response = RestClient.get(wca_api_profile_url(wi.join(",")))
        persons = JSON.parse(persons_response.body)
        persons.each do |p|
          puts "Importing #{p["person"]["name"]}"
          _, person_obj = Person.create_or_update(p)
          names << p["person"]["name"]
        end
      end
      puts "Done."
      if names.any?
        message = "Las personas siguientes se han importado con éxito: #{names.join(", ")}."
        NotificationMailer.with(task_name: "get_wca_persons", message: message).notify_team_of_job_done.deliver_now
      end
    rescue => err
      puts "Could not get persons from the WCA, error:"
      puts err
      puts "---"
      puts "Trying to notify the administrators."
      NotificationMailer.with(task_name: "get_wca_persons", error: err).notify_team_of_failed_job.deliver_now
    end
  end

  desc "Daily task to send subscriptions reminder"
  task :send_subscription_reminders => :environment do
    users_to_notify = User.subscription_notification_enabled.select(&:last_active_subscription).select do |u|
      u.last_active_subscription.until == 2.days.from_now.to_date
    end
    puts "#{users_to_notify.size} usuarios a notificar."
    users_done = []
    users_to_notify.each do |u|
      puts u.name
      begin
        NotificationMailer.with(user: u).notify_of_expiring_subscription.deliver_now
        users_done << u
      rescue => err
        puts "Could not notify user!"
        NotificationMailer.with(task_name: "send_subscription_reminders", error: err).notify_team_of_failed_job.deliver_now
      end
    end
    message = "Número de usuarios notificados: #{users_done.size}/#{users_to_notify.size}"
    if users_done.any?
      message += " (#{users_done.map(&:name).join(", ")})"
    end
    message += "."
    NotificationMailer.with(task_name: "send_subscription_reminders", message: message).notify_team_of_job_done.deliver_now
  end
end
