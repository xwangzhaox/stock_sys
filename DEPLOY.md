# shiyingbi 部署流程

## 服务器信息
CentOS Linux release 7.9.2009 (Core)

更新系统包
`$ yum update`

## 添加新的发布用户

### SSH-Keygen登录
生成并复制自身ssh-keygen
```
$ cd ~/.ssh
$ ssh-keygen -t rsa -C "[email@example.com]"
$ ssh-add id_rsa
$ pbcopy < ~/.ssh/id_rsa.pub
```
如果遇到-bash: cd: ~/.ssh: No such file or directory的错误，新建一个.ssh 的文件夹即可。
`$ mkdir ~/.ssh`

这时候我们切换到 ssh 的 Profile，输入以下的命令：
`$ mkdir ~/.ssh`
`$ vi ~/.ssh/authorized_keys`

通过 vi 把刚刚复制到剪贴板的内容粘贴到 authorized_keys 里，然后保存退出。
`$ vi /etc/ssh/sshd_config`
找到
`#AuthorizedKeysFile      %h/.ssh/authorized_keys`

把#AuthorizedKeysFile %h/.ssh/authorized_keys前面的注释删掉，修改成
`AuthorizedKeysFile      %h/.ssh/authorized_keys`

按照常规应该是重启 sshd，service sshd restart结果这个命令报错没有 sshd 这个服务，懒得去 debug 了，直接reboot好了。
`$ reboot`

### 新建用户
`$ adduser wwwroot`
`$ vi /etc/sudoers`
找到root ALL=(ALL:ALL) ALL这一行，在后面添加：
`wwwroot ALL=(ALL:ALL) ALL`

/etc/sudoers 默认是只读权限，使用 vi 编辑好之后用wq!命令来强制修改即可，不需要去改权限。

然后，我们需要切换到这个用户配置一下 ssh-keygen：
```
$ su - wwwroot
$ mkdir ~/.ssh
$ vi ~/.ssh/authorized_keys
```
最后，再配置一下 iTerm2 的 Profiles

## 部署环境

重新打开 iTerm 使用 wwwroot 的 ssh 连接，以后我们的操作都会在这个 ssh 里完成。

### 安装RVM
用 RVM 安装 Ruby

要安装 RVM，在终端中输入下面的命令：
```
# 安装rvm会使用到的包
$ yum install gcc-c++ patch readline readline-devel zlib zlib-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison iconv-devel sqlite-devel
# 安装GPG keys
$ gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
# 安装rvm
$ \curl -sSL https://get.rvm.io | bash -s stable
```
找不到有效的 OpenPGP 数据
请执行（加入了代理，可以不加）：
```
$ command curl -x socks://127.0.0.1:1080 -sSL https://rvm.io/mpapis.asc | gpg2 --import -
$ command curl -x socks://127.0.0.1:1080 -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
$ \curl -x socks://127.0.0.1:1080 -sSL https://get.rvm.io | bash -s stable
```
加入到bashrc
```
$ echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"' >>~/.bashrc
$ source ~/.bashrc
$ rvm -v
```
检查更新依赖包
```
$ rvm requirements
$ rvm pkg install readline
$ rvm pkg install openssl
```

### 安装ruby
速度会比较慢，可以开启全局代理再安装
```
$ export ALL_PROXY=socks://127.0.0.1:1080
$ source ~/.bashrc
$ rvm install 2.0.0
$ rvm use 2.0.0 --default
# 安装rails
gem install rails -v '6.1.4'
```

### 安装Nginx
```
sudo yum install nginx
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl status nginx
```

### 安装mysql
```
wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
sudo rpm -ivh mysql57-community-release-el7-9.noarch.rpm
sudo yum install mysql-server mysql-devel
```
输出mysql初始化log，找到临时密码
```
$ sudo cat /var/log/mysqld.log
# [Note] A temporary password is generated for root@localhost: lqTCyP8&/vl/
$ mysql -uroot -p
# 更新密码
$ set password=password("yourpassword");
# 刷新
$ flush privileges;
# 新建数据库
$ CREATE DATABASE shiyingbi CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 安装redis
```
$ sudo yum update
$ sudo yum -y install redis
$ sudo systemctl start redis
$ sudo systemctl enable redis
```
修改配置，重启服务
```
$ sudo vi /etc/redis.conf
# 找到requirepass foobared，将foobared改成你的密码，然后保存
$ sudo systemctl restart redis
$ redis-cli
  auth yourpassword
```

### 安装nodejs和webpack
```
$ curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
$ sudo yum install nodejs
$ npm install --global yarn
$ npm install webpack@4.46.0
$ npm install webpack-cli
```

### 安装git
```
$ sudo yum install git
$ git config --global user.name ""
$ git config --global user.email youremail@youremail.com
```
拷贝本地的ssh key添加到github账号中
`$ pbcopy ~/.ssh/id_rsa.pub`

### 部署
systemd创建sidekiq.service
```
$ cd /etc/systemd/system
$ touch sidekiq.service
$ vi sidekiq.service
# 新建之后开启服务，开启开机启动
$ sudo systemctl start sidekiq
$ sudo systemctl enable sidekiq
```
```
[Unit]
Description=sidekiq
After=syslog.target network.target

[Service]
Type=notify
WatchdogSec=10

WorkingDirectory=/home/wwwroot/www/shiyingbi/current

ExecStart=/home/wwwroot/.rvm/bin/rvm 3.0.0 in /home/wwwroot/www/shiyingbi/current do bundle exec sidekiq -e production
ExecReload=/bin/kill -TSTP $MAINPID

Environment=MALLOC_ARENA_MAX=2

RestartSec=1
Restart=on-failure

StandardOutput=syslog
StandardError=syslog

SyslogIdentifier=sidekiq

[Install]
WantedBy=default.target
```

systemd创建puma_shiyingbi_production.service
```
$ cd /etc/systemd/system
$ touch puma_shiyingbi_production.service
$ vi puma_shiyingbi_production.service
# 新建之后开启服务，开启开机启动
$ sudo systemctl start puma_shiyingbi_production
$ sudo systemctl enable puma_shiyingbi_production
```
```
[Unit]
Description=Puma HTTP Server for mysite (production)
After=network.target

[Service]
Type=simple
User=wwwroot
ExecStart=/bin/bash -lc 'cd /home/wwwroot/www/shiyingbi/current;bundle exec puma -e production -C /home/wwwroot/www/shiyingbi/shared/config/puma.rb -b unix:///home/wwwroot/www/shiyingbi/shared/tmp/sockets/puma.sock'
ExecStop=/home/wwwroot/.rvm/bin/rvm 3.0.0 do bundle exec pumactl -S /home/wwwroot/www/shiyingbi/shared/tmp/pids/puma.pid stop

PIDFile=/home/wwwroot/www/shiyingbi/shared/tmp/pids/puma.pid
Restart=always

[Install]
WantedBy=multi-user.target
```
本地执行部署命令
`$ cap production deploy`

添加Nginx配置
```
upstream puma {
  server unix:///home/wwwroot/www/shiyingbi/shared/tmp/sockets/puma.sock;
}

server {
    listen 80;
    server_name erp.shiyingbi.com;

    root /home/wwwroot/www/shiyingbi/current/public;
    access_log /home/wwwroot/www/shiyingbi/shared/log/nginx.access.log;
    error_log /home/wwwroot/www/shiyingbi/shared/log/nginx.error.log;

    location ^~ /assets/ {
        gzip_static on;
        expires max;
        add_header Cache-Control public;
    }

    location ^~ /javascripts/ {
        gzip_static on;
        expires max;
        add_header Cache-Control public;
    }

    try_files $uri/index.html $uri @puma;
    location @puma {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;

        proxy_pass http://puma;
    }

    error_page 500 502 503 504 /500.html;
    client_header_buffer_size 16K;
    large_client_header_buffers 4 64K;
    client_body_buffer_size  512k;
    client_max_body_size 10M;
    keepalive_timeout 10;
}
```

# Docker 部署

> 开发流程设计如下：

开发环境：在本地部署环境并开发、本地测试
测试环境：可切换分支到开发分支，从新build docker后发布到测试环境，在远端服务器进行测试
生产环境：暂未涉及分布式需求，因此暂时仍然采用cap发布的方式进行发布

## 测试环境

### 本地build image

```sh
docker-compose up -d
```

### 发布到docker hub

```sh
./release.sh
```