class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :league_classification, :league_regulations]
  before_action :redirect_unless_admin!, except: [:show, :index, :subscribe, :new, :create, :league_classification, :league_regulations]
  before_action :redirect_unless_comm!, except: [:show, :subscribe, :new, :create, :league_classification, :league_regulations]

  # Amount in cents
  ANNUAL_SUBSCRIPTION_COST=1000

  def index
    @subscribers = Subscription.active.includes(:user).order(:name).group_by do |s|
      "#{s.name.downcase}"
    end.values.map(&:first)
  end

  def show
    @subscribers = Subscription.active.includes(:user).order(:name).group_by do |s|
      "#{s.name.downcase}"
    end.values.map(&:first)
  end

  def create
    @amount = ANNUAL_SUBSCRIPTION_COST

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Cuota de socio anual de la AMS',
      :currency    => 'eur'
    )

    current_user.add_subscription(
      charge.id,
      charge.amount,
    )

    NotificationMailer.with(user: current_user).notify_new_subscriber.deliver_now

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_subscription_path
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy
    flash[:success] = "Suscripción eliminada"
    redirect_to subscriptions_list_url
  end

  def league_classification
    @classification_2019 = CLASSIFICATION_2019
  end

  def league_regulations
  end

  CLASSIFICATION_2019 = [
    {
      position: "1ª",
      name: "Manuel Prieto de Antón",
      wca_id: "2015ANTO04",
      points: "906.74",
    },
    {
      position: "2ª",
      name: "Alberto Pérez de Rada Fiol",
      wca_id: "2011FIOL01",
      points: "360.58",
    },
    {
      position: "3ª",
      name: "José Antonio Navarro Sánchez",
      wca_id: "2015SANC18",
      points: "352.92",
    },
    {
      position: "4ª",
      name: "Raúl Martínez Redondo",
      wca_id: "2017REDO02",
      points: "306.27",
    },
    {
      position: "5ª",
      name: "Jaime Botello García",
      wca_id: "2016GARC52",
      points: "299.81",
    },
    {
      position: "6ª",
      name: "Adrián Martínez Macías",
      wca_id: "2013MACI01",
      points: "217.53",
    },
    {
      position: "7ª",
      name: "Rafael Rodríguez Santana",
      wca_id: "2012SANT12",
      points: "179.39",
    },
    {
      position: "8ª",
      name: "Eder Olivencia González",
      wca_id: "2012GONZ10",
      points: "174.16",
    },
    {
      position: "9ª",
      name: "Daniel Ortega Pastor",
      wca_id: "2014PAST03",
      points: "165.43",
    },
    {
      position: "10ª",
      name: "Jesús Lindo García",
      wca_id: "2013GARC08",
      points: "165.01",
    },
    {
      position: "11ª",
      name: "Javier Tovar Castro",
      wca_id: "2016CAST23",
      points: "133.46",
    },
    {
      position: "12ª",
      name: "Iván Brigidano Pérez",
      wca_id: "2016PERE44",
      points: "130.03",
    },
    {
      position: "13ª",
      name: "María del Mar Gallego Vicente",
      wca_id: "2013VICE01",
      points: "123.79",
    },
    {
      position: "14ª",
      name: "Sergio Torrijos Santano",
      wca_id: "2013SANT13",
      points: "111.44",
    },
    {
      position: "15ª",
      name: "Jorge Marín Segovia",
      wca_id: "2016SEGO02",
      points: "92.42",
    },
    {
      position: "16ª",
      name: "Leonard Wetzel",
      wca_id: "2016WETZ01",
      points: "73.51",
    },
    {
      position: "17ª",
      name: "Jesús Masanet García",
      wca_id: "2004MASA01",
      points: "65.19",
    },
    {
      position: "18ª",
      name: "Alejandro Soriano",
      wca_id: "2018SORI06",
      points: "57.92",
    },
    {
      position: "19ª",
      name: "Pablo Serrano Santos",
      wca_id: "2017SANT63",
      points: "55.74",
    },
    {
      position: "20ª",
      name: "Clara Mompradé Mahedero",
      wca_id: "2017MAHE13",
      points: "55.13",
    },
    {
      position: "21ª",
      name: "Adrián Otayza Rojas",
      wca_id: "2017ROJA22",
      points: "54.73",
    },
    {
      position: "22ª",
      name: "Laura Freitas Martín",
      wca_id: "2018MART18",
      points: "53.87",
    },
    {
      position: "23ª",
      name: "Fernando Astasio Ávila",
      wca_id: "2016AVIL02",
      points: "51.37",
    },
    {
      position: "24ª",
      name: "Sofía Guerrero Neto",
      wca_id: "2017NETO02",
      points: "50",
    },
    {
      position: "25ª",
      name: "Pablo Aguilar Domínguez",
      wca_id: "2010AGUI04",
      points: "48.37",
    },
    {
      position: "26ª",
      name: "Diego Arche Andradas",
      wca_id: "2015ANDR06",
      points: "42.6",
    },
    {
      position: "27ª",
      name: "César Pérez García",
      wca_id: "2008PERE01",
      points: "40",
    },
    {
      position: "27ª",
      name: "Manuel Jesús Carrasco Ruiz",
      wca_id: "2014RUIZ14",
      points: "40",
    },
    {
      position: "27ª",
      name: "Roberto Sánchez",
      wca_id: "2017SANC44",
      points: "40",
    },
    {
      position: "30ª",
      name: "Julio Perugorria Lorente",
      wca_id: "2014LORE02",
      points: "36.71",
    },
    {
      position: "31ª",
      name: "Leon Jakub Wyrobek",
      wca_id: "2016WYRO01",
      points: "34.34",
    },
    {
      position: "32ª",
      name: "Javier Matesanz Sala",
      wca_id: "2017SALA28",
      points: "30",
    },
    {
      position: "32ª",
      name: "Mikel Pérez Iniesto",
      wca_id: "2017INIE02",
      points: "30",
    },
    {
      position: "34ª",
      name: "Daniele Vanoli Hernández",
      wca_id: "2016HERN05",
      points: "23.54",
    },
    {
      position: "35ª",
      name: "Luis Javier Sanz Sardina",
      wca_id: "2015SARD02",
      points: "21.6",
    },
    {
      position: "36ª",
      name: "Carlos Chamizo Cano",
      wca_id: "2016CANO02",
      points: "21.41",
    },
    {
      position: "37ª",
      name: "Alejandro Darío Castro Lázaro",
      wca_id: "2018LAZA10",
      points: "20",
    },
    {
      position: "37ª",
      name: "Álvaro Tovar Castro",
      wca_id: "2016CAST22",
      points: "20",
    },
    {
      position: "37ª",
      name: "Daniel del Olmo Rodrigo",
      wca_id: "2018RODR42",
      points: "20",
    },
    {
      position: "37ª",
      name: "David Pérez Muñoz",
      wca_id: "2018MUNO10",
      points: "20",
    },
    {
      position: "37ª",
      name: "Héctor Castro Lázaro",
      wca_id: "2018LAZA11",
      points: "20",
    },
    {
      position: "37ª",
      name: "José Miguel Lorente Pérez",
      wca_id: "2016PERE08",
      points: "20",
    },
    {
      position: "37ª",
      name: "Mario Díez del Corral",
      wca_id: "2018CORR05",
      points: "20",
    },
    {
      position: "37ª",
      name: "Pablo Domínguez Balbás",
      wca_id: "2019BALB01",
      points: "20",
    },
    {
      position: "37ª",
      name: "Santiago Borrego Verde",
      wca_id: "2016VERD05",
      points: "20",
    },
    {
      position: "46ª",
      name: "Adrian Elvías Lozano",
      wca_id: "2019LOZA05",
      points: "10",
    },
    {
      position: "46ª",
      name: "Alejandro Pazat de Lys López",
      wca_id: "2019LOPE22",
      points: "10",
    },
    {
      position: "46ª",
      name: "Bryant Borrego Alvarado",
      wca_id: "2019ALVA04",
      points: "10",
    },
    {
      position: "46ª",
      name: "Gabriel Pérez Navarro",
      wca_id: "2019NAVA02",
      points: "10",
    },
    {
      position: "46ª",
      name: "Jaime Solsona",
      wca_id: "2010SOLS01",
      points: "10",
    },
    {
      position: "46ª",
      name: "Marco Zucchi Mesia",
      wca_id: "2019MESI01",
      points: "10",
    },
    {
      position: "46ª",
      name: "Roberto Martínez Macías",
      wca_id: "2014MACI01",
      points: "10",
    },
  ].freeze

end
