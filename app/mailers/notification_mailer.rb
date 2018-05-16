class NotificationMailer < ApplicationMailer
  def notify_of_expiring_subscription
    @user = params[:user]
    mail(to: @user.email, subject: "Votre adhésion à l'AFS arrive à expiration")
  end

  def notify_team_of_failed_job
    @task_name = params[:task_name]
    @error = params[:error]
    mail(to: "admin@speedcubingfrance.org", subject: "[cron.afs] Une tâche a échouée")
  end
end
