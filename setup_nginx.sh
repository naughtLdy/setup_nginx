#!/bin/bash

pkgs=(
	'libpcre3'
	'libpcre3-dev'
	'libssl-dev'
)

nginx_dir_name='nginx-1.9.7'
nginx_dl_file=$nginx_dir_name'.tar.gz'
nginx_dl_url='http://nginx.org/download/'$nginx_dl_file
nginx_install_path='/usr/local/nginx'
src_path='/usr/local/src'

if [ "$#" -eq "0" ];then
  echo "usage: $0 --install"
  echo "usage: $0 --config"
  echo "usage: $0 --reinstall"
  echo "usage: $0 --uninstall"
  exit 0
fi

if [ "$1" = '--install' ]; then

  current_dir=`pwd`
	for (( i=0; i<${#pkgs[@]}; i++ ))
  do
    apt-get -y install ${pkgs[$i]}
  done

  useradd nginx -s /bin/false

  cd $src_path
  wget $nginx_dl_url -O $src_path/$mysql_dl_file
  tar xfz $src_path/$nginx_dl_file
  cd $nginx_dir_name
  ./configure --prefix=$nginx_install_path --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --user=nginx --group=nginx --with-http_ssl_module
  make
  make install

  if [ $? -ne 0 ]; then
    echo "Install failed!!"
    exit 1
  fi

  cd $current_dir
  cp -r etc/init.d/* /etc/init.d
  cp -r etc/logrotate.d/* /etc/logrotate.d

  echo "Install success!!"

elif [ "$1" = '--config' ]; then
  cp -r front/conf $nginx_install_path
  cp -r front/sites-available $nginx_install_path
  cp -r front/sites-enabled $nginx_install_path

  echo "'$nginx_install_path/ssl'にSSLサーバ証明書を設置して、'/etc/init.d/nginx start'を実行してください"

  # 自動起動登録(debian only)
  insserv nginx
  systemctl enable nginx
  systemctl start nginx

elif [ "$1" = '--reinstall'  ]; then
    /etc/init.d/nginx stop

    wget $nginx_dl_url -P $src_path
    tar xfz $src_path/$nginx_dl_file
    cd $nginx_dir_name
    ./configure --prefix=$nginx_install_path --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --user=nginx --group=nginx --with-http_ssl_module
    make
    make install
    cd ../

    /etc/init.d/nginx start

    rm -r $nginx_dir_name

elif [ "$1" = '--uninstall' ]; then
    echo "DELETE ALL NGINX FILE. Are you sure?"
    /etc/init.d/nginx stop
    rm /etc/init.d/nginx
    rm -r $src_path/$nginx_dir_name $nginx_install_path
fi

