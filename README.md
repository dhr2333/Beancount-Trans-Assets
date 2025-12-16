# Beancount-Trans-Assets

为 Beancount 账本提供标准化的组织结构，支持两种使用方式：

1. **独立使用**：作为个人记账的账本模板（适合普通用户）
2. **平台使用**：作为 [Beancount-Trans](https://trans.dhr2333.cn) 平台的账本仓库模板（适合平台用户）

## 📁 目录结构

```text
.
├── 2022_template/  # 年度账本模板
│   ├── 00.bean  # 年度入口文件
│   ├── 01-expenses.bean  # 1 月支出
│   ├── ...  # 其他月份支出
│   ├── 12-expenses.bean  # 12 月支出
│   └── ...  # 专项文件（如收入、报销、价格、查询等）
├── account/  # 账户定义目录
│   ├── assets.bean  # 资产账户
│   ├── equity.bean  # 权益账户
│   ├── expenses.bean  # 支出账户
│   ├── income.bean  # 收入账户
│   └── liabilities.bean  # 负债账户
├── depreciation.bean  # 折旧记录
├── document/  # 文档存储目录（用于 Fava 文档功能）
├── main.bean  # 主账本入口文件
├── trans/  # 平台解析结果目录（由平台自动管理），默认`.gitignore`忽略且不建议修改
└── .gitignore  # Git 忽略配置
```

## 👤 普通用户指南

### 1. 如何开始记账

当需要记录新一年的账本时：

1. 复制 `2022_template/` 目录并重命名为对应年份（如 `2023/`）
2. 在 `main.bean` 中添加对应的 include 语句：

```beancount
include "2023/00.bean"
```

### 2. 运行账本

选择以下任一方式运行：

#### 🐳 Docker Compose（推荐）

```yaml
docker compose up -d
```

访问：<http://127.0.0.1:5000>

#### 🐳 Docker CLI

```bash
docker run -d \
    --name=beancount-trans-assets \
    -v $PWD:/Assets \
    -e BEANCOUNT_FILE=/Assets/main.bean \
    -p 5000:5000 \
    dhr2333/beancount-trans-assets:latest
```

#### 💻 命令行

```bash
pipenv install  # 安装虚拟环境
pipenv shell  # 进入虚拟环境
pip install beancount fava  # 安装包
fava main.bean  # 运行该项目
```

### 📚 学习资源

- [Beancount 入门教程](https://trans.dhr2333.cn/docs/blog/2024/08/17/%E5%80%9F%E8%B4%B7%E8%AE%B0%E8%B4%A6%E6%B3%95)
- [Fava 官方文档](https://beancount.github.io/fava/)

## ⚙️ 平台用户指南

### 平台解析结果

如果您使用 [Beancount-Trans 平台](https://trans.dhr2333.cn)：

1. **解析结果位置**：平台解析账单后，结果会自动写入 `trans/` 目录
2. **Git 管理**：`trans/` 目录已在 `.gitignore` 中被忽略，避免与您的本地修改冲突
3. **查看结果**：解析完成后，结果会直接在平台账本中显示

### 重要提示

- ❌ **请勿手动修改** `.gitignore` 和 `trans/` 目录下的文件
- 🔄 每次平台解析都会覆盖该目录内容
- 📁 您本地的其他账本文件（如 `2023/`、`account/` 等）不会被平台修改

## 🆘 获取帮助

- **普通用户问题**：请查阅上方学习资源或提交 [GitHub Issue](https://github.com/dhr2333/Beancount-Trans-Assets/issues)
- **平台相关问题**：请通过 Beancount-Trans [GitHub Issue](https://github.com/dhr2333/Beancount-Trans/issues) 反馈
