# 目录结构

为所有用户提供账本组织结构，目录结构如下：

![2024-03-10_12-52](https://daihaorui.oss-cn-hangzhou.aliyuncs.com/djangoblog/202403101253726.png)

# 账单规范

对于23年的账单，将"2022_template"文件复制粘贴重命名为2023。23年的所有账单存储于2023目录中。

以月进行记录，以年进行存档。

入门教程：[Beancount 入门教程](https://www.dhr2333.cn/article/2022/9/10/52.html)

# 运行项目

```shell
pip install beancount
pip install fava
fava main.bean
```
