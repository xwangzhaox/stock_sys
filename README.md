# Ecommerce

快速引导
-------

**安装**

1. 克隆远端库到本地
`git clone git@github.com:keqinzhao/ecommerce.git`

2. 安装node
`npm install`

3. 初始化前端依赖的包
`yarn install`

如果报错现实yarn未安装，则用npm安装后再执行之前的步骤
`npm install yarn -g`

4. 初始化数据库及基础数据
`rake db:migrate`

5. 如果本地应用sqlite数据库，请在本地修改下sql中的日期格式化函数
位置位于：
`app/controllers/users_controller.rb:39:in `show'`
把`DATE_FORMAT(created_at,"%Y-%m-%d")`改为`datetime(created_at , "%Y-%m-%d")`