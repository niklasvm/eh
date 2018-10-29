#!/bin/bash/

echo "$PWD";

# make directory
mkdir /home/rstudio/.ssh/;

# create key
cat "$PWD/id_rsa" > /home/rstudio/.ssh/id_rsa;

# set permissions
chmod 600 /home/rstudio/.ssh/id_rsa;
chmod 700 /home/rstudio/.ssh;
eval "$(ssh-agent -s)";
ssh-add /home/rstudio/.ssh/id_rsa;


# set user info
git config --global user.email "email address";
git config --global user.name "username";
git config --global core.fileMode false;

# restart rstudio-server
rstudio-server kill-all;
rstudio-server restart;
