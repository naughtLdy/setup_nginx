# setup_nignx

Shellscript for install and setup nginx

## usage

$ sudo ./setup_nginx.sh --install
$ sudo ./setup_nginx.sh --config

$ cd /usr/local/nginx/sites-available
$ sudo cp sample.conf.default hogefuga.conf

(You must use "conf" to extention of filename)

$ sudo ln -s hogefuga.conf ../sites-enabled
$ sudo /usr/local/nginx/sbin/nginx -t

("-t" means configtest)

$ sudo service nginx start

Have a fun !!!!!

## Extra (Japanese)

- Ubuntuでしか動作確認してません
- reinstall,deleteというオプションもあります
- 英語間違ってるかも。ご指摘ください。

## ToDo (Japanese)

- インデントをちゃんとする
- install と config わける必要なさそう

