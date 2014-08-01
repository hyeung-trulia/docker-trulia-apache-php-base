#!/bin/bash

# CWD
BASEPATH=$(dirname $(perl -MCwd=realpath -e "print realpath '$0'"))
run_env=dev

function usage 
{
    echo "usage: fe_docker.sh [[[-e environment [dev|stage|live] ] [-i]] | [-h]]"
}

function geoip_data_check
{
    # untar GeoIP data TODO figure out where is this comming from and how i can get this dynamically
    if [ -d "${BASEPATH}/GeoIP" ]; then
        echo "GeoIP dir exists already. no need to untar the GeoIP.tar file."
    else
       if [ -f "${BASEPATH}/GeoIP.tgz" ]; then
           tar -zxvf ./GeoIP.tgz
       else
           echo "both GeoIP dir and GeoIP.tgz file do not exist. major problem here. exiting..."
           exit -1;
       fi
    fi
}

# generates list of available dns servers for docker
function get_dns_flags {
  # get list of nameservers and prepend each with --dns flag
  cat /etc/resolv.conf | grep "nameserver" | grep "." | awk '{ printf " --dns %s",$2; }'
}

# copy dev_local.conf and .htaccess
function cp_dev_config_files {
  cp ./site_config/${run_env}/dev_local.conf ./web/include/
  cp ./site_config/${run_env}/.htaccess ./web/
  cp ./site_config/${run_env}/common.conf ./common/
}

# docker run memcached
function run_memcached_docker {
  for i in `seq 1 3`
  do
    running=$(docker ps | grep memcached$i);
    echo "$running";
    if [ "${running}" ]; then
      echo "memcached$i container is running already...";
    else
      echo "memcached is not running. starting it...";
      docker run -d --name memcached$i -p 1121$i:11211 tutum/memcached
    fi
  done
}

###### main

while [ "$1" != "" ]; do
    case $1 in
        -e | --env )           shift
                                run_env=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

echo "run_env: ${run_env}"

geoip_data_check
cp_dev_config_files
dns_flag=$(get_dns_flags)
run_memcached_docker

if [ "$run_env" = "dev" ]; then
    docker run -t -i -v ${BASEPATH}/scripts:/var/www/scripts -v ${BASEPATH}/GeoIP:/data/GeoIP -v ${BASEPATH}/db_config/dev:/var/www/common/db_handle -v ${BASEPATH}/web:/var/www/web -v ${BASEPATH}/common:/var/www/common/common -p 8080:80 ${dns_flag} --link memcached1:memcached1 --link memcached2:memcached2 --link memcached3:memcached3 hyeung/docker-trulia-apache-php-base sh -c "/var/www/scripts/start_apache2_memcached.sh && bash"
elif [ "$run_env" = "stage" ]; then
    docker run -t -i -v ${BASEPATH}/scripts:/var/www/scripts -v ${BASEPATH}/GeoIP:/data/GeoIP -v ${BASEPATH}/db_config/stage:/var/www/common/db_handle -v ${BASEPATH}/web:/var/www/stage -v ${BASEPATH}/common:/var/www/common/common -p 8080:80 ${dns_flag} hyeung/docker-trulia-apache-php-base bash 
elif [ "$run_env" = "live" ]; then
    docker run -t -i -v ${BASEPATH}/scripts:/var/www/scripts -v ${BASEPATH}/GeoIP:/data/GeoIP -v ${BASEPATH}/db_config/live:/var/www/common/db_handle -v ${BASEPATH}/web:/var/www/live -v ${BASEPATH}/common:/var/www/common/common -p 80:80 ${dns_flag} hyeung/docker-trulia-apache-php-base bash 
fi

