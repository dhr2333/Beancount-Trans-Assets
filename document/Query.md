## Beancount BQL

在以下模板中进行微调获取自己实际需要的数据

### 获取每年每月支出总和

```BQL
SELECT year, month, sum(position) AS total_expenses
WHERE account ~ 'Expenses'
GROUP BY year, month
```

### 获取每年的收入总和

```BQL
SELECT year, sum(position) AS total_income
WHERE account ~ 'Income'
GROUP BY year
```

### 查询所有个人应收款

```BQL
SELECT payee,sum(position)
WHERE account = 'Assets:Receivables:Personal'
```

### Collect

查询每个商家的支出
```BQL
SELECT payee,SUM(COST(position)) AS balance
WHERE account ~ 'Expenses'
GROUP BY payee
```
