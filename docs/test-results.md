# 試験結果

## 1. 手動構築環境

### Webアクセス確認

EC2上でApacheを起動し、ブラウザからHTTPアクセスを確認した。

結果：

```text
AWS Terraform Hands-on
```

表示を確認し、正常と判断した。

### EC2 → RDS 疎通確認

EC2からRDSのTCP/5432へ接続確認を実施した。

```bash
nc -vz -w 5 "$RDSHOST" 5432
```

結果：

```text
Connected to RDS:5432
```

正常に接続できることを確認した。

### PostgreSQL TLS接続確認

```bash
psql "host=$RDSHOST port=5432 dbname=webappdb user=postgres sslmode=verify-full sslrootcert=./global-bundle.pem"
```

結果：

```text
SSL connection (protocol: TLSv1.3)
webappdb=>
```

TLS接続に成功した。

### DBデータ確認

```sql
SELECT * FROM employees;
```

結果：

| id | name | department |
|---:|---|---|
| 1 | Sato | Infrastructure |
| 2 | Tanaka | Network |
| 3 | Suzuki | Cloud |

3件のデータを確認した。

### Web → RDS連携確認

PHPからRDS PostgreSQLへ接続し、`employees` テーブルのデータをブラウザに表示した。

結果：

```text
Employee List

1  Sato    Infrastructure
2  Tanaka  Network
3  Suzuki  Cloud
```

正常に表示できることを確認した。

---

## 2. Terraform構築試験

### terraform validate

```bash
terraform validate
```

結果：

```text
Success! The configuration is valid.
```

### terraform plan

```bash
terraform plan
```

結果：

```text
Plan: 12 to add, 0 to change, 0 to destroy.
```

### terraform apply

```bash
terraform apply
```

結果：

```text
Apply complete! Resources: 12 added, 0 changed, 0 destroyed.
```

12リソースの作成に成功した。

---

## 3. Terraform再構築後の動作確認

### Webアクセス

Terraformで作成したEC2へブラウザからアクセスした。

結果：

```text
AWS Terraform Hands-on
Created by Terraform
```

正常に表示できることを確認した。

### SSH接続

Terraformで作成したEC2へSSH接続した。

結果：

```text
[ec2-user@ip-10-0-1-141 ~]$
```

正常にログインできることを確認した。

### EC2 → RDS TCP/5432

```bash
nc -vz -w 5 "$RDSHOST" 5432
```

結果：

```text
Connected to 10.0.12.169:5432
```

Security Group経由でRDSへ接続できることを確認した。

### PostgreSQL TLS接続

結果：

```text
SSL connection (protocol: TLSv1.3)
webappdb=>
```

Terraformで再構築したRDSにもTLS接続できることを確認した。

### DBデータ確認

```sql
SELECT * FROM employees;
```

結果：

| id | name | department |
|---:|---|---|
| 1 | Sato | Infrastructure |
| 2 | Tanaka | Network |
| 3 | Suzuki | Cloud |

正常にデータを参照できることを確認した。

### Web → RDS連携

Terraformで再構築した環境でもPHPからRDSへ接続し、ブラウザにDBデータを表示した。

結果：

```text
Employee List

1  Sato    Infrastructure
2  Tanaka  Network
3  Suzuki  Cloud
```

正常に表示できることを確認した。

---

## 4. terraform destroy

```bash
terraform destroy
```

結果：

```text
Destroy complete! Resources: 12 destroyed.
```

全リソースの削除に成功した。

### Terraform State確認

```bash
terraform state list
```

出力なし。

Terraform管理対象のリソースが残っていないことを確認した。

### 再構築可能性確認

削除後に再度実行した。

```bash
terraform plan
```

結果：

```text
Plan: 12 to add, 0 to change, 0 to destroy.
```

Terraformコードから同じAWSインフラを再構築可能な状態であることを確認した。
