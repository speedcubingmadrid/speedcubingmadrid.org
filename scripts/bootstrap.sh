apt-get update
apt-get install -y curl git vim htop apt-transport-https

# Create ams user if does not exist.
if ! id -u ams &>/dev/null; then
  useradd -m -s /bin/bash ams
  chown ams:ams /home/ams
fi

echo "Setting up ssh keys for members."

tmp_authorized_keys_path="/tmp/authorized_keys"
for user in albertopdrf; do
  public_keys_url="https://github.com/$user.keys"

  echo "" >> $tmp_authorized_keys_path
  echo "# Keys for $user" >> $tmp_authorized_keys_path
  curl -s $public_keys_url >> $tmp_authorized_keys_path
done

su ams -c "mkdir -p /home/ams/.ssh"
su ams -c "touch /home/ams/.ssh/authorized_keys"
mv /home/ams/.ssh/authorized_keys /home/ams/.ssh/authorized_keys.bak
chown ams:ams /tmp/authorized_keys
mv /tmp/authorized_keys /home/ams/.ssh


# Setting up rails and db

# Will hold environment variables with secrets
touch /tmp/secrets

echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update

apt-get install -y postgresql-10

user_exists=`sudo -u postgres psql -tAc "select 1 from pg_catalog.pg_roles where rolname='speedcubingmadrid';"`

if [ "x$user_exists" != "x1" ]; then
  password=`openssl rand -base64 16`
  sudo -u postgres psql -c "create role speedcubingmadrid login password '$password' createdb;"
  su ams -c "echo 'DATABASE_PASSWORD=$password' >> /home/ams/.env.production"
fi

# to build rbenv
apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev gcc g++ make

# install nodejs and yarn
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# install stretch backports for certbot
echo "deb http://ftp.debian.org/debian stretch-backports main" | tee /etc/apt/sources.list.d/certbot.list
# this runs apt-get update
curl -sL https://deb.nodesource.com/setup_10.x | bash -

# libpq-dev is for pg gem
apt-get install -y nodejs yarn libpq-dev


# for certbot
apt-get install -y python-certbot-nginx -t stretch-backports

if [ ! -d /home/ams/speedcubingmadrid.org ]; then
  su ams -c "cd /home/ams && git clone https://github.com/speedcubingmadrid/speedcubingmadrid.org.git /home/ams/speedcubingmadrid.org"
fi
apt-get install -y nginx
cp /home/ams/speedcubingmadrid.org/prod_conf/ams.conf /etc/nginx/conf.d/
cp /home/ams/speedcubingmadrid.org/prod_conf/pre_certif.conf /etc/nginx/conf.d/
# Create an empty https conf since we don't have a certificate yet
touch /etc/nginx/ams_https.conf

service nginx restart

read -p "Do you want to create a new certificate for the server? (N/y)" user_choice
if [ "x$user_choice" == "xy" ]; then
  /home/ams/speedcubingmadrid.org/scripts/prod_cert.sh create_cert
  cp /home/ams/speedcubingmadrid.org/prod_conf/ams_https.conf /etc/nginx/
  rm /etc/nginx/conf.d/pre_certif.conf
  cp /home/ams/speedcubingmadrid.org/prod_conf/post_certif.conf /etc/nginx/conf.d/
  service nginx restart
fi

echo "Installing cron scripts"
cp /home/ams/speedcubingmadrid.org/scripts/cert_nginx /etc/cron.weekly

echo "Bootstraping as ams"
su ams -c "cd /home/ams && /home/ams/speedcubingmadrid.org/scripts/ams_bootstrap.sh"
