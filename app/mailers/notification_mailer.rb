class NotificationMailer < ApplicationMailer
  def notify_of_expiring_subscription
    @user = params[:user]
    mail(to: @user.email, subject: "[AMS] Tu condición de socio está a punto de caducar")
  end

  def notify_team_of_failed_job
    @task_name = params[:task_name]
    @error = params[:error]
    mail(to: "admin@speedcubingfrance.org", subject: "[cron.afs][error] Una tarea ha fallado")
  end

  def notify_team_of_job_done
    @task_name = params[:task_name]
    @message = params[:message]
    mail(to: "admin@speedcubingfrance.org", subject: "[cron.afs][info] #{@task_name}")
  end
end
