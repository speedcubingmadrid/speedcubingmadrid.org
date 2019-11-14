class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :ranking, :medal_collection, :league_classification, :league_regulations]
  before_action :redirect_unless_admin!, except: [:show, :ranking, :medal_collection, :index, :subscribe, :new, :create, :league_classification, :league_regulations]
  before_action :redirect_unless_comm!, except: [:show, :ranking, :medal_collection, :subscribe, :new, :create, :league_classification, :league_regulations]

  # Amount in cents
  ANNUAL_SUBSCRIPTION_COST=1000

  def index
    @subscribers = User.with_active_subscription.order(:name).group_by do |s|
      "#{s.name.downcase}"
    end.values.map(&:first)
  end

  def show
    @subscribers = User.with_active_subscription.order(:name).group_by do |s|
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

  def ranking
    @events = ["333", "222", "444", "555", "666", "777", "333bf", "333fm", "333oh", "333ft", "clock", "minx", "pyram", "skewb", "sq1", "444bf", "555bf", "333mbf"]
    event = "#{params[:event_id]}"
    format = "#{params[:format][0]}"
    wca_ids = User.with_active_subscription.map(&:wca_id)
    @query = "#{format}_#{event}"
    @persons = Person.where(wca_id: wca_ids).where("#{@query} IS NOT NULL").order("#{@query} ASC")
  end

  def medal_collection
    wca_ids = User.with_active_subscription.map(&:wca_id)
    @persons = Person.where(wca_id: wca_ids).where("gold > 0 or silver > 0 or bronze > 0").order(gold: :desc, silver: :desc, bronze: :desc)
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
      points: "1447.84",
    },
  {
      position: "2ª",
      name: "Raúl Martínez Redondo",
      wca_id: "2017REDO02",
      points: "532.97",
    },
 {
      position: "3ª",
      name: "Jaime Botello García",
      wca_id: "2016GARC52",
      points: "466.37",
    },
 {
      position: "4ª",
      name: "Alberto Pérez de Rada Fiol",
      wca_id: "2011FIOL01",
      points: "444.6",
    },
 {
      position: "5ª",
      name: "Eder Olivencia González",
      wca_id: "2012GONZ10",
      points: "354.8",
    },
 {
      position: "6ª",
      name: "José Antonio Navarro Sánchez",
      wca_id: "2015SANC18",
      points: "352.92",
    },

    {
      position: "7ª",
      name: "Adrián Martínez Macías",
      wca_id: "2013MACI01",
      points: "331.67",
    },
 {
      position: "8ª",
      name: "Jorge Marín Segovia",
      wca_id: "2016SEGO02",
      points: "306.66",
    },
 {
      position: "9ª",
      name: "Javier Tovar Castro",
      wca_id: "2016CAST23",
      points: "217.03",
    },
 {
      position: "10ª",
      name: "Daniel Ortega Pastor",
      wca_id: "2014PAST03",
      points: "202.85",
    },
 {
      position: "11ª",
      name: "Iván Brigidano Pérez",
      wca_id: "2016PERE44",
      points: "196.71",
    },
  {
      position: "12ª",
      name: "Rafael Rodríguez Santana",
      wca_id: "2012SANT12",
      points: "179.39",
    },
 {
      position: "13ª",
      name: "Julen Simón Iriarte",
      wca_id: "2014IRIA01",
      points: "173.01",
    },
 {
      position: "14ª",
      name: "María del Mar Gallego Vicente",
      wca_id: "2013VICE01",
      points: "166.65",
    },
 {
      position: "15ª",
      name: "Sergio Torrijos Santano",
      wca_id: "2013SANT13",
      points: "165.76",
    },
 {
      position: "16ª",
      name: "Jesús Lindo García",
      wca_id: "2013GARC08",
      points: "165.01",
    },
 {
      position: "17ª",
      name: "Alejandro Soriano",
      wca_id: "2018SORI06",
      points: "135.11",
    },
 {
      position: "18ª",
      name: "Clara Mompradé Mahedero",
      wca_id: "2017MAHE13",
      points: "98.82",
    },
 {
      position: "19ª",
      name: "Pablo Serrano Santos",
      wca_id: "2017SANT63",
      points: "93.16",
    },
 {
      position: "20ª",
      name: "Leon Jakub Wyrobek",
      wca_id: "2016WYRO01",
      points: "34.34",
    },
    {
      position: "21ª",
      name: "Jesús Masanet García",
      wca_id: "2004MASA01",
      points: "88.29",
    },
 {
      position: "22ª",
      name: "Julio Perugorria Lorente",
      wca_id: "2014LORE02",
      points: "78.58",
    },
    {
      position: "23ª",
      name: "Laura Freitas Martín",
      wca_id: "2018MART18",
      points: "77.49",
    },
 {
      position: "24ª",
      name: "Leonard Wetzel",
      wca_id: "2016WETZ01",
      points: "73.51",
    },
 {
      position: "25ª",
      name: "Fernando Astasio Ávila",
      wca_id: "2016AVIL02",
      points: "71.37",
    },
 {
      position: "26ª",
      name: "Luis Javier Sanz Sardina",
      wca_id: "2015SARD02",
      points: "63.37",
    },
 {
      position: "27ª",
      name: "César Pérez García",
      wca_id: "2008PERE01",
      points: "60",
    },
 {
      position: "27ª",
      name: "Manuel Jesús Carrasco Ruiz",
      wca_id: "2014RUIZ14",
      points: "60",
    },
 {
      position: "27ª",
      name: "Roberto Sánchez",
      wca_id: "2017SANC44",
      points: "60",
    },
 {
      position: "27ª",
      name: "Sofía Guerrero Neto",
      wca_id: "2017NETO02",
      points: "60",
    },
    {
      position: "31ª",
      name: "Mikel Pérez Iniesto",
      wca_id: "2017INIE02",
      points: "58.58",
    },
    {
      position: "32ª",
      name: "Adrián Otayza Rojas",
      wca_id: "2017ROJA22",
      points: "54.73",
    },
 {
      position: "33ª",
      name: "Diego Arche Andradas",
      wca_id: "2015ANDR06",
      points: "52.6",
    },
 {
      position: "34ª",
      name: "Carlos Chamizo Cano",
      wca_id: "2016CANO02",
      points: "50.92",
    },
 {
      position: "35ª",
      name: "Pablo Aguilar Domínguez",
      wca_id: "2010AGUI04",
      points: "48.37",
    },
 {
      position: "36ª",
      name: "Daniele Vanoli Hernández",
      wca_id: "2016HERN05",
      points: "48.33",
    },
 {
      position: "37ª",
      name: "Alejandro Darío Castro Lázaro",
      wca_id: "2018LAZA10",
      points: "40",
    },
 {
      position: "37ª",
      name: "Daniel del Olmo Rodrigo",
      wca_id: "2018RODR42",
      points: "40",
    },
 {
      position: "37ª",
      name: "Héctor Castro Lázaro",
      wca_id: "2018LAZA11",
      points: "40",
    },
  {
      position: "37ª",
      name: "Javier Matesanz Sala",
      wca_id: "2017SALA28",
      points: "40",
    },
 {
      position: "37ª",
      name: "Santiago Borrego Verde",
      wca_id: "2016VERD05",
      points: "40",
    },
  {
      position: "42ª",
      name: "Álvaro Tovar Castro",
      wca_id: "2016CAST22",
      points: "34.86",
    },
    {
      position: "43ª",
      name: "José Miguel Lorente Pérez",
      wca_id: "2016PERE08",
      points: "32.62",
    },
 {
      position: "44ª",
      name: "Adrian Elvías Lozano",
      wca_id: "2019LOZA05",
      points: "30",
    },
 {
      position: "44ª",
      name: "David Pérez Muñoz",
      wca_id: "2018MUNO10",
      points: "30",
    },
 {
      position: "44ª",
      name: "Pablo Domínguez Balbás",
      wca_id: "2019BALB01",
      points: "30",
    },
 {
      position: "47ª",
      name: "Celia López Martín",
      wca_id: "2014MART44",
      points: "26.55",
    },
 {
      position: "48ª",
      name: "Gonzalo Blanco Herrero",
      wca_id: "2015HERR12",
      points: "21.54",
    },
 {
      position: "49ª",
      name: "Sergio Ortiz Rodríguez",
      wca_id: "2015RODR29",
      points: "21.4",
    },
 {
      position: "50ª",
      name: "Alejandro Pazat de Lys López",
      wca_id: "2019LOPE22",
      points: "20",
    },
 {
      position: "50ª",
      name: "Bryant Borrego Alvarado",
      wca_id: "2019ALVA04",
      points: "20",
    },
 {
      position: "50ª",
      name: "Fausto Muñoz Simonet",
      wca_id: "2019SIMO06",
      points: "20",
    },
 {
      position: "50ª",
      name: "Francisco Montañés Barbudo",
      wca_id: "2014BARB07",
      points: "20",
    },
 {
      position: "50ª",
      name: "Gabriel Pérez Navarro",
      wca_id: "2019NAVA02",
      points: "20",
    },
 {
      position: "50ª",
      name: "Marco Zucchi Mesia",
      wca_id: "2019MESI01",
      points: "20",
    },

     {
      position: "50ª",
      name: "Mario Díez del Corral",
      wca_id: "2018CORR05",
      points: "20",
    },
 {
      position: "57ª",
      name: "Jaime Solsona",
      wca_id: "2010SOLS01",
      points: "10",
    },
 {
      position: "57ª",
      name: "Martín Augusto Reigadas Teran",
      wca_id: "2015TERA01",
      points: "10",
    },
 {
      position: "57ª",
      name: "Rafael Alférez Robisco",
      wca_id: "2015ROBI03",
      points: "10",
    },
 {
      position: "57ª",
      name: "Roberto Martínez Macías",
      wca_id: "2014MACI01",
      points: "10",
    },

  ].freeze

end
