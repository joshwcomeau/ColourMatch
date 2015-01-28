Restarting the Server
===================

###Shutting Down
SSH into the server (`ssh deploy@colourmatch.ca`) and type `sudo poweroff` or `sudo reboot`/

###Starting the web and app servers:
When Ubuntu restarts, neither nginx nor puma will be running.

#####Nginx
Type the following from the SSH'ed terminal:

```$ sudo service nginx start```

#####Puma
From your LOCAL machine (NOT SSH), in the project root, type:

```$ cap production deploy:restart```

This uses capistrano to connect and start Puma with all the right production settings.