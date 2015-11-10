# Node Template Project Technical Documentation

## Folder structure

- ```Makefile``` - Indicates how to build stuff in order that you
  don't need to understand how everything works in order to run it.
- ```composer.json``` - Composer configuration.
- ```package.json``` - NPM configuration.
- ```build/``` - scripts used by the build process (e.g. to upgrade the database)
- ```src/``` - Javascript (and a little bit of PHP) source.
  - ```main/``` - Server run-time stuff.
  - ```test/``` - Unit tests.
- ```lib/``` - Compiled JavaScript files (same subdirectory structure as ```test/```)
- ```config/``` - Deployment configuration.
- ```www/``` - static files.
- ```node_modules/``` - NPM-managed JavaScript libraries.
- ```vendor/``` - Composer-managed PHP libraries.

This is intentionally very similar to the layout used by PHPTemplateProject.
If you know that, you mostly know this.

## Database
### Create the database

```make create-database``` will attempt to create the database for you
based on configuration in ```config/dbc.json```.

If that fails (due to e.g. your system is not set up in a way for
which that script is designed) you can create the database yourself:

Set up a new postgres database by logging in as root
(```sudo -u postgres psql``` often does the trick)
and running:

```sql
CREATE DATABASE nodetemplateprojectdatabase;
CREATE USER nodetemplateprojectdatabaseuser WITH PASSWORD 'nodetemplateprojectdatabasepassword';
GRANT ALL PRIVILEGES ON DATABASE nodetemplateprojectdatabase TO nodetemplateprojectdatabaseuser;
```

If you've changed the name of the database or user in
```config/dbc.json```, make the corresponding changes to the above
SQL.

### Initialize the database

Once a database exists and permissions are set up for our user, you
should be able to run ```make upgrade-database```, which will run all
the upgrade scripts to create and populate the
```nodetemplateprojectdatabasenamespace``` schema.
