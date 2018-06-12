apt-get update
apt-get install -y curl git vim htop

# Create afs user if does not exist.
if ! id -u afs &>/dev/null; then
  useradd -m -s /bin/bash afs
  chown afs:afs /home/afs
fi

echo "Setting up ssh keys for members."

tmp_authorized_keys_path="/tmp/authorized_keys"
for user in viroulep zeecho; do
  public_keys_url="https://github.com/$user.keys"

  echo "" >> $tmp_authorized_keys_path
  echo "# Keys for $user" >> $tmp_authorized_keys_path
  curl -s $public_keys_url >> $tmp_authorized_keys_path
done

su afs -c "mkdir -p /home/afs/.ssh"
su afs -c "touch /home/afs/.ssh/authorized_keys"
mv /home/afs/.ssh/authorized_keys /home/afs/.ssh/authorized_keys.bak
chown afs:afs /tmp/authorized_keys
mv /tmp/authorized_keys /home/afs/.ssh


# Setting up rails and db

# Will hold environment variables with secrets
touch /tmp/secrets

echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update

apt-get install -y postgresql-10

user_exists=`sudo -u postgres psql -tAc "select 1 from pg_catalog.pg_roles where rolname='speedcubingfrance';"`

if [ "x$user_exists" != "x1" ]; then
  password=`openssl rand -base64 16`
  sudo -u postgres psql -c "create role speedcubingfrance login password '$password' createdb;"
  su afs -c "echo 'DATABASE_PASSWORD=$password' >> /home/afs/.env.production"
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

if [ ! -d /home/afs/speedcubingfrance.org ]; then
	# FIXME : change v2 to master
  su afs -c "git clone -b v2 https://github.com/speedcubingfrance/speedcubingfrance.org.git /home/afs/speedcubingfrance.org"
fi
apt-get install -y nginx
cp /home/afs/speedcubingfrance.org/prod_conf/afs.conf /etc/nginx/conf.d/
cp /home/afs/speedcubingfrance.org/prod_conf/afs_https.conf /etc/nginx/

service nginx restart

read -p "Do you want to create a new certificate for the server? (N/y)" user_choice
if [ "x$user_choice" == "xy" ]; then
  /home/afs/speedcubingfrance.org/scripts/prod_cert.sh create_cert
fi

echo "Installing cron scripts"
cp /home/afs/speedcubingfrance.org/scripts/cron_weekly.sh /etc/cron.weekly

echo "Bootstraping as AFS"
su afs -c "/home/afs/speedcubingfrance.org/scripts/afs_bootstrap.sh"
