# speedcubingfrance.org

Ce dépôt contient les sources du site [speedcubingfrance.org](http://www.speedcubingfrance.org).

# Dépendances et installation

Le site est basé sur Rails (et nécessite donc Ruby), et est déployé sur un VPS.
La base de donnée utilisée est PostgreSQL, qu'il est nécessaire d'installer pour faire tourner le site en local.

## Lancer le site en local

Les dépendances sont gérées via `bundler`, la première chose à faire est donc de lancer `bundle install --path vendor/bundle`.
Le site gère ses dépendances javascript via Yarn, il faut donc les installer également via `bin/yarn`.

Avant de lancer le site, il faut créer et initialiser la base de données.
En local la configuration est disponible dans `config/database.yml`, et le site s'attend à pouvoir utiliser l'utilisateur `speedcubingfrance` avec le mot de passe `fas`.
Il faut donc le créer dans PostgreSQL et lui donner les droits de créer des bases de données.

Une fois fait, la base de données s'initialise via `bin/rails db:setup`.

Le serveur peut se lancer via `bin/rails s`.

### Authentification avec la WCA

L'authentification sur le site se fait via les comptes WCA.
Le plus simple pour développer en local reste de faire tourner le site de la WCA en local (car vous pourrez vous logguer comme n'importe quel utilisateur).
Dans tous les cas il faut créer une application Oauth sur l'instance du site de la WCA que vous ciblez (locale, ou la production), cela ce fait [ici](https://www.worldcubeassociation.org/oauth/applications) pour sur le site "production" de la WCA.
L'URL de callback est la page gérant l'authentification sur le site de l'AFS, en local il s'agit de `http://127.0.0.1:3000/wca_callback` (par défaut le serveur tourne sur le port 3000, à adapter si besoin).

Une fois cela fait, il faudra ajouter l'id de l'application et le secret à l'environnement local ; le site peut charger des variables d'environnement depuis un fichier `.env`, il suffit donc de créer un fichier `.env` à la racine de ce dépôt.
Il contiendra par exemple ceci :

```bash
WCA_CLIENT_ID="xxxxxx"
WCA_CLIENT_SECRET="xxxxxxx"
# Adresse du site de la WCA à utiliser
# À commenter pour utiliser la version de production
WCA_BASE_URL="http://localhost:1234"
```

Il suffit ensuite de redémarrer le serveur pour qu'il prenne en compte ces variables d'environnement.

### Import des compétitions à venir

Elle se fait via `bin/rails scheduler:get_wca_competitions`.

### Ajout d'un administrateur

Par défaut il n'y a aucun administrateur sur le site.
Connectez vous au moins une fois sur le site, puis ouvrez une console Rails via `bin/rails c`.
Si vous ne connaissez pas votre user id WCA, vous pouvez l'obtenir en regardant le dernier utilisateur ajouté (ici 277) :

```
irb(main):001:0> User.last
  User Load (0.7ms)  SELECT  "users".* FROM "users" ORDER BY "users"."id" DESC LIMIT $1  [["LIMIT", 1]]
=> #<User id: 277, name: "Philippe Virouleau", wca_id: "2008VIRO01", country_iso2: "FR", email: "277@worldcubeassociation.org", avatar_url: "http://localhost:1234/uploads/user/avatar/2008VIRO...", avatar_thumb_url: "http://localhost:1234/uploads/user/avatar/2008VIRO...", gender: "m", birthdate: "1954-12-04", created_at: "2018-05-17 13:35:29", updated_at: "2018-05-17 13:35:29", delegate_status: "delegate", admin: false, communication: false, french_delegate: false, notify_subscription: false>
```

Il suffit alors de mettre le champ `admin` à `true` manuellement :

```
irb(main):002:0> User.find(277).update(admin: true)
  User Load (0.9ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 277], ["LIMIT", 1]]
   (0.3ms)  BEGIN
  SQL (0.9ms)  UPDATE "users" SET "admin" = $1, "updated_at" = $2 WHERE "users"."id" = $3  [["admin", "t"], ["updated_at", "2018-05-17 13:40:37.844392"], ["id", 277]]
  ...
   (63.7ms)  COMMIT
=> true
```

Vous pouvez ensuite gérer les autres utilisateurs via l'interface du site.

### Lancer des migrations

Via le standard `bin/rails db:migrate`.

## Déployer en production

### Premier déploiement (bootstrap)

Une fois le VPS d'OVH (ré)-installé, il faut récupérer le fichier `scripts/bootstrap.sh` et l'exécuter.

`wget https://raw.githubusercontent.com/speedcubingfrance/speedcubingfrance.org/v2/scripts/bootstrap.sh`
`./bootstrap.sh`

FIXME: changer v2 quand la branche est fusionnée

Il devrait :

  - Installer les packages nécessaires
  - Créer l'utilisateur afs
  - Installer les clés publiques github des admins
  - Cloner le dépôt speedcubingfrance.org
  - Configurer l'utilisateur postgres
  - Mettre en place le `DATABASE_PASSWORD` dans les variables d'environnements (dans le fichier `.env.production`).
  - Éventuellement créer un certificat (il faut rentrer l'adresse email de l'AFS)
  - Installer nginx et sa configuration
  - Installer le cron pour le renouvellement du certificat
  - Lancer le bootstrap AFS

Le bootstrap AFS quand à lui devrait :

  - Installer rbenv et la version de ruby nécessaire pour le site
  - Installer le crontab des jobs rake
  - Optionnellement mettre en place rails et une db vierge
  - Optionnellement mettre en place les variables d'environnements (dans le fichier `.env.production`)

### Déploiement régulier

Le script `deploy.sh` contient des commandes utiles pour le déploiement :

  - `pull_latest` : récupère la dernière master.
  - `restart_app` : (re)-démarre le serveur puma.
  - `rebuild_rails` : installe les gems ruby, recompile les assets, et lance `restart_app`.

Il suffit alors de lancer :

`ssh afs@dev.speedcubingfrance.org speedcubingfrance.org/scripts/deploy.sh pull_latest rebuild_rails`

Et de se logguer pour effectuer les éventuelles migrations (ne pas oublier de redémarrer de serveur après les migrations !).


## Backup

Pour récupérer un backup de la base de données de production :

`pg_dump -Fc --no-acl --no-owner -h localhost -U speedcubingfrance speedcubingfrance-prod > prod.dump`

## Restauration d'un backup

### En production

Mettre latest.dump sur le serveur, et lancer :
`pg_restore --verbose --clean --no-acl --no-owner -h localhost -U speedcubingfrance -d speedcubingfrance-prod latest.dump`


### En local

`pg_restore --verbose --clean --no-acl --no-owner -h localhost -U speedcubingfrance -d speedcubingfrance-dev latest.dump`

## Sendgrid


Sendgrid est utilisé pour envoyer des emails depuis la production.

La seule chose à savoir est qu'il faut mettre en place l'API key pour que le système d'envoi de mail fonctionne.

Le dashboard est là : https://app.sendgrid.com/
(cf les logins/mdp)

Pour tester l'envoi de mail en local, il suffit de démarrer `mailcatcher` (en local les emails sont envoyés au smtp localhost).


# Fonctionnalités

## Pour tous

  - Calendrier des compétitions officielles, en préparation, événements AFS.
  - Export du calendrier au format iCal, pour l'ajouter comme calendrier externe à votre agenda (`/competitions.ics`).
  - Prochaines compétitions en France

## Pour les membres et compétiteurs

  - (TODO) Liste de ressources externes
  - Liste des cotisations
  - Notification 2 jours avant que l'adhésion n'expire

## Pour les organisateurs (et Délégués WCA)

  - Administration des compétitions pour afficher les membres exemptés de frais d'inscription, ou vérifier les nouveaux compétiteurs

## Pour les Délégués et l'administration de l'AFS

  - Gestion du matériel et calendrier prévisionnel
  - Import des cotisations depuis HelloAsso

## Pour l'équipe communication et l'administration de l'AFS

  - Calendrier des événements
  - Articles et tags
  - Gestion des compétitions internationales à afficher en page d'accueil (CdF, Euro, WC)
