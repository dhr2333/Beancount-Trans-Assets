# Beancount-Trans-Assets

为 [Beancount-Trans](https://github.com/dhr2333/Beancount-Trans) 提供标准化的 Beancount 账本模板：平台为用户创建 Git 账本仓库时，会读取本仓库 `main` 分支的内容作为初始账本。

## 目录结构

```text
.
├── main.bean          # 账本主入口：账户、插件、Fava 选项与 include
├── account/           # 账户定义
│   ├── assets.bean
│   ├── equity.bean
│   ├── expenses.bean
│   ├── income.bean
│   └── liabilities.bean
├── 2022_template/     # 年度账本模板
│   ├── 00.bean        # 年度入口，include 各月度文件
│   └── 01.bean ~ 12.bean   # 月度账本
├── .gitignore
└── Dockerfile、docker-compose.yaml、requirements.txt  # 本地运行 Fava（可选）
```

## 平台集成约定

- **模板来源**：平台通过 GitHub API 读取本仓库 `main` 分支。
- **标题替换**：平台会将 `main.bean` 中的 `option "title" "xxx的账本"` 替换为用户名。
- **`trans/` 目录**：由平台写入并维护（解析结果、对账指令等），已在 `.gitignore` 中忽略，请勿手动修改。
- **年月账本**：平台按 `{年份}/` 目录写入月度文件（如 `2023/01.bean`），并在 `main.bean` 中补充 `include "{年份}/00.bean"`。

## 新增年度账本

复制 `2022_template/` 并重命名为目标年份，然后在 `main.bean` 中补充 include：

```beancount
include "2023/00.bean"
```

## License

[MIT](LICENSE)
