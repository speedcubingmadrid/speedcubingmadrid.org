# `speedcubingmadrid.org`

This repository contains the source code that runs on [speedcubingmadrid.org](http://www.speedcubingmadrid.org).

# Functionalities

## For everyone

  - Calendar of official competitions in Madrid, in Spain, being prepared, and AMS events.
  - Calendar export on iCal format to add it as an external calendar to your calendar (`/competitions.ics`).
  - Galeries of competitions' photos.

## For members and competitors

  - List of subscriptions.
  - Rankings of members
  - Medal collection ranking of members.
  - Automatic notification 2 days before subscriptions expire.
  - Automatic notification when new competitions are announced.

## For organizers

  - Administering competitions to view members with discounts on registration fees, or check new competitors.

## For AMS administrators

  - Material management and estimated schedule.
  - Post and tags.
  - Management of championships to display on home page (SC, WEC, WWC).
  - Automatically synced mailing lists.

# Dependencies and installation

This section and the following are for people wishing to contribute to the **development** of the AMS website.

The website is based on Rails (and therefore requires Ruby), and is deployed on a VPS.
The database used is PostgreSQL, which must be installed to run the website locally.

## Launch the website locally

The dependencies are managed via `bundler`, so the first thing to do is to run `bundle install --path vendor/bundle`.
The website manages its JavaScript dependencies via Yarn, so you have to install them via `bin/yarn` as well.

Before launching the website, you must create and initialize the database.
Locally, the configuration is available in `config/database.yml`, and the website expects to be able to use the user `speedcubingmadrid` with the password `fas`.
It must be created in PostgreSQL and given the rights to create databases.

Once done, the database is initialized via `bin/rails db:setup`. You would also need to run `bin/rake db:reset` to set up test database and then `bin/rake assets:precompile` to compile some assets needed for tests to run.

Use `bin/rails s` to launch the server. To use it together with the WCA website server running locally, use `bin/rails s -p 1234` instead.

### Authentication via WCA

The authentication on the website is handled using WCA accounts.
The easiest way to develop locally is to run the WCA website locally (because you can log in like any user).
In any case you need to create an Oauth application on the instance of the WCA website you are targeting (local, or production), this is [here](https://www.worldcubeassociation.org/oauth/applications) for on the "production" website of the WCA.
The URL of callback is the page managing the authentication on the site of the AMS, locally it is `http://localhost:1234/wca_callback`.

Once this is done, it will be necessary to add the id of the application and the secret to the local environment; the website can load environment variables from a `.env` file, so just create a `.env` file at the root of the repository.
It will contain for example this:

```bash
WCA_CLIENT_ID="xxx"
WCA_CLIENT_SECRET="yyy"
WCA_BASE_URL="http://localhost:3000"

STRIPE_PUBLISHABLE_KEY="pk_test_zzz"
STRIPE_SECRET_KEY="sk_test_ttt"
```

Then restart the server to take into account these environment variables.

### Import upcoming competitions

It's done via `bin/rails scheduler:get_wca_competitions`.

### Import persons

It's done via `bin/rails scheduler:get_wca_persons`.

### Add an administrator

By default there is no administrator on the website.
Log in at least once to the website, then open a Rails console via `bin/rails c`.
If you don't know your WCA `user.id`, you can get it by looking at the last user added (here 1273):

```
irb(main):001:0> User.last
  User Load (0.7ms)  SELECT  "users".* FROM "users" ORDER BY "users"."id" DESC LIMIT $1  [["LIMIT", 1]]
=> #<User id: 1273, name: "Alberto Pérez de Rada Fiol", wca_id: "2011FIOL01", country_iso2: "ES", email: "1273@worldcubeassociation.org", avatar_url: "http://localhost:1234/uploads/user/avatar/2011FIOL...", avatar_thumb_url: "http://localhost:1234/uploads/user/avatar/2011FIOL...", gender: "m", birthdate: "1954-12-04", created_at: "2018-12-27 18:37:30", updated_at: "2018-12-27 18:37:30", delegate_status: "delegate", admin: false, communication: false, spanish_delegate: true, notify_subscription: true>
```

Then just update the field `admin` to `true` manually:

```
irb(main):002:0> User.find(1273).update(admin: true)
  User Load (0.9ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1273], ["LIMIT", 1]]
   (0.3ms)  BEGIN
  SQL (0.9ms)  UPDATE "users" SET "admin" = $1, "updated_at" = $2 WHERE "users"."id" = $3  [["admin", "t"], ["updated_at", "2018-12-27 18:37:37"], ["id", 1273]]
  ...
   (63.7ms)  COMMIT
=> true
```

Other users can then be managed through the website user interface.

### Run the migrations

Via the standard `bin/rails db:migrate`.

## Production

See the [dedicated wiki page](https://github.com/speedcubingmadrid/speedcubingmadrid.org/wiki/AMS-Production-Server).

## Sendgrid

Sendgrid is used to send emails in production.

The only thing to know is that you have to set up the API key for the mail sending system to work.

The dashboard is in: https://app.sendgrid.com/

To test the sending of mail locally, just start `mailcatcher` (locally emails are sent to smtp localhost).

## Stripe

Stripe is used to charge the subscription fee to members.

The only thing to know is that you have to set up the API key for the automated subscription system to work.

## AWS

An AWS bucket is used to store the photos of competitions' galleries, which are uploaded through `Active Storage`.

The public and private keys, the region, and the name of the bucket must be set up.

## G Suite

G Suite is used to manage the association's mailing lists. They are synced via `bin/rails scheduler:sync_groups`. To install it for the first time:

  1. Enable google API in google settings.
  2. Enable google developer console for all users.
  3. Go to the google developer console, create a new project, add the API "Admin SDK".
  4. Create "credentials" of type oauth, download the JSON and re-name it to `oauth_credentials.json`.
  5. Install [`gcloud`](https://cloud.google.com/sdk/docs/quickstart-debian-ubuntu).
  6. Authenticate with **the API bot** account of the AMS, by running: `gcloud beta auth application-default login --scopes = 'https: //www.googleapis.com/ auth / admin.directory.group '--client-id-file = oauth_credentials.json`

This should automatically create a JSON file:

```
Credentials saved to file: [/home/apdrf/.config/gcloud/application_default_credentials.json]
```

This file must be copied to the root of the project on the production server, renaming it to `credentials.json`. It is loaded by the corresponding library [here](https://github.com/speedcubingmadrid/speedcubingmadrid.org/blob/master/lib/gsuite_mailing_lists.rb#L4).

If a production server is re-installed, step 6 will need to be repeated.
