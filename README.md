# 目录结构

为所有用户提供账本组织结构，目录结构如下：

![](https://daihaorui.oss-cn-hangzhou.aliyuncs.com/djangoblog/202503061727934.png)

# 账单规范

对于23年的账单，将"2022_template"文件复制粘贴重命名为2023。23年的所有账单存储于2023目录中。

以月进行记录，以年进行存档。

入门教程：[Beancount 入门教程](https://www.dhr2333.cn/article/2022/9/10/52.html)

# 运行项目

若是通过docker compose运行的Beancount-Trans项目可直接通过 http://127.0.0.1:5000 访问

也可单独运行账单:

```shell
pipenv install  # 安装虚拟环境
pipenv shell  # 进入虚拟环境
pip install beancount fava  # 安装包
fava main.bean  # 运行该项目
```