# Ecommerce

快速引导
-------

**安装**

1. 克隆远端库到本地
`git@github.com:xwangzhaox/stock_sys.git`

2. 安装node
`npm install`

3. 初始化前端依赖的包
`yarn install`

如果报错现实yarn未安装，则用npm安装后再执行之前的步骤
`npm install yarn -g`

4. 初始化数据库及基础数据
`rake db:migrate`