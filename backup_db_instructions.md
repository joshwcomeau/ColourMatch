Database Backup & Restore
===================

###To Back up:
Use the pg_dump tool like so:
```$ pg_dump ColourMatch_production > filename```

This dumps the structure *and* the data. If you only want the data, you can use:
```$ pg_dump ColourMatch_production -a -f filename```

This happens twice a week automatically on the server via cron.

###To Restore:
There are two Postgres roles required to re-create the database structure: 'deploy' and 'postgres'.
Create these roles with `createuser ROLENAME` from the terminal (NOT from a PSQL console)
```$ createuser postgres
$ createuser deploy```

Then, create the database if it doesn't already exist, 'inheriting' from template0
```$ createdb -T template0 ColourMatch_production```

**Note: If you've done a partial restore, or an old restore, you'll need to delete and re-create the database.**

We're finally ready to import. Use this terminal command. 
```$ psql ColourMatch_production < filename``

There are some dated database backups you can use in /backups/.
