class NotificationMailer < ApplicationMailer
  def notify_new_subscriber
    @user = params[:user]
    mail(to: @user.email, subject: "[AMS] Correo de bienvenida")
  end

  def notify_of_expiring_subscription
    @user = params[:user]
    mail(to: @user.email, subject: "[AMS] Tu condición de socio está a punto de caducar")
  end

  def notify_team_of_failed_job
    @task_name = params[:task_name]
    @error = params[:error]
    mail(to: "administradores@speedcubingmadrid.org", subject: "[cron.ams][error] Una tarea ha fallado")
  end

  def notify_team_of_job_done
    @task_name = params[:task_name]
    @message = params[:message]
    mail(to: "administradores@speedcubingmadrid.org", subject: "[cron.ams][info] #{@task_name}")
  end
end
