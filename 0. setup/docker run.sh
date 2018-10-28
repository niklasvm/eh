# inputs
container_name="rstudio";
pwd="hello"

# run container
sudo docker run \
  --name $container_name \
  -it -d \
  # forward rstudio and shiny
  -p 8787:8787 \
  -p 80:3838 \
  # mount entire home folder
  -v ~/:/home/rstudio/ \
  # other params
  -e PASSWORD="$pwd" \
  -e ROOT=TRUE \
  --restart on-failure \
  rocker/verse;

# install tools
sudo docker exec -it $container_name bash -c "apt-get update; apt-get install -y htop python-pip wget gdebi-core";
sudo docker exec -it $container_name bash -c "pip install glances";

# install rstudio preview
url="https://s3.amazonaws.com/rstudio-ide-build/server/trusty/amd64/rstudio-server-1.2.1070-amd64.deb";
name="${url##*/}"; # parse name
sudo docker exec -it $container_name bash -c "wget $url;";
sudo docker exec -it $container_name bash -c "gdebi -n $name";

# set up git
sudo docker exec -it $container_name bash -c "cd /home/rstudio/eh/0. setup/; bash ./set up git.sh";

# restart rstudio server
sudo docker exec -it $container_name bash -c "rstudio-server stop; rstudio-server kill-all; rstudio-server start";

# create shell shortcut
echo "sudo docker exec -it $container_name bash;" > ~/docker.sh;
sudo chmod +x ~/docker.sh;


# open shell
sudo docker exec -it $container_name bash;
