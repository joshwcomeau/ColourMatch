curdate="$(date +'%Y%m%d')"
echo "Creating DB backup - $curdate"

cd ~/ColourMatch/backups
pg_dump ColourMatch_production -a -f "db_backup_$curdate"