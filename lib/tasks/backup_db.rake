namespace :backup  do
  desc "Create daily backups of our important data"
  task :db => :environment do
    sh("sh /home/deploy/ColourMatch/current/backup_db.sh")
  end
end
