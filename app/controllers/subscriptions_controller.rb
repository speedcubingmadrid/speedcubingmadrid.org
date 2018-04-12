require 'csv'

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_unless_admin!

  def index
    @subscribers = Subscription.active.includes(:user).order(:firstname, :name).group_by do |s|
      "#{s.firstname.downcase} #{s.name.downcase}"
    end.values.map(&:first)
  end

  def subscriptions_list
    @subscriptions = Subscription.all.order(payed_at: :desc)
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy
    flash[:success] = "Cotisation supprimée"
    redirect_to subscriptions_list_url
  end

  def import
    subscriptions = params.require(:subscriptions)
    subscriptions.each do |sub|
      sub_params = sub.permit(:name, :firstname, :wca_id, :email, :payed_at, :receipt_url)
      # We may add/change it later, so we cannot use it for the find
      wca_id = sub_params.delete(:wca_id)
      new_subscription = Subscription.find_or_initialize_by(sub_params)
      unless wca_id.blank?
        new_subscription.wca_id = wca_id
      end
      # We separate the find and the save so that any possible WCA ID is set when entering after_create callbacks
      new_subscription.save!
    end
    redirect_to subscriptions_list_url
  end

  def review_csv
    csvfile = params.require(:import_form).require(:csvfile)
    @new_subscriptions = []
    @subscriptions = []
    if csvfile.methods.include?(:path)
      CSV.foreach(csvfile.path, :headers => true, :col_sep => ';') do |row|
        # Row follows this format:
        # ;;;;;name;firstname;;date;;;;;email;;receipt_url;;;;buyer name;buyer firstname;;;;;wca_id
        subscription = Subscription.find_or_initialize_by(name: row[5].strip,
                                                          firstname: row[6].strip,
                                                          payed_at: row[8],
                                                          email: row[13].strip,
                                                          receipt_url: row[15])
        subscription.wca_id = row[25]
        if subscription.new_record?
          @new_subscriptions << subscription
        else
          @subscriptions << subscription
        end
      end
    end
    render :review_import
  end
end
