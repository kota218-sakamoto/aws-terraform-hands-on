# 構築手順

## 1. 手動構築

AWS Management Consoleから以下の順番で構築した。

1. VPC作成
2. Public Subnet作成
3. Private Subnetを2AZに作成
4. Internet Gateway作成・VPCへアタッチ
5. Public Route Table作成
6. Public SubnetとRoute Tableを関連付け
7. EC2用Security Group作成
8. RDS用Security Group作成
9. EC2起動
10. Apache / PHPインストール
11. RDS PostgreSQL作成
12. EC2からRDSへ接続確認
13. WebページからRDSデータ表示

## 2. 手動環境での確認

EC2からRDSの5432番ポートへ疎通確認を実施した。

```bash
nc -vz -w 5 "$RDSHOST" 5432
```

PostgreSQLへTLS接続した。

```bash
psql "host=$RDSHOST port=5432 dbname=webappdb user=postgres sslmode=verify-full sslrootcert=./global-bundle.pem"
```

`employees` テーブルを作成し、テストデータを登録した。

```sql
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50)
);
```

```sql
INSERT INTO employees (name, department) VALUES
('Sato', 'Infrastructure'),
('Tanaka', 'Network'),
('Suzuki', 'Cloud');
```

## 3. Terraform化

手動構築後、同等のAWSインフラをTerraformコードとして作成した。

主なファイルは以下。

```text
main.tf
providers.tf
variables.tf
outputs.tf
terraform.tfvars.example
scripts/user_data.sh
```

Terraformの初期化と構文確認を実施した。

```bash
terraform init
terraform fmt
terraform validate
```

## 4. 手動環境の削除

Terraformによる再現性を確認するため、手動で作成した以下のリソースを削除した。

- RDS
- EC2
- DB Subnet Group
- Security Group
- Route Table
- Internet Gateway
- Subnet
- VPC

## 5. Terraformによる再構築

以下を実行した。

```bash
terraform plan
terraform apply
```

実行結果：

```text
Apply complete! Resources: 12 added, 0 changed, 0 destroyed.
```

Terraformで以下を再構築した。

- VPC × 1
- Subnet × 3
- Internet Gateway × 1
- Route Table × 1
- Route Table Association × 1
- Security Group × 2
- DB Subnet Group × 1
- EC2 × 1
- RDS PostgreSQL × 1

## 6. Terraform再構築後の確認

以下を確認した。

- EC2のWebページへHTTPアクセス可能
- EC2へSSH接続可能
- EC2からRDSのTCP/5432へ接続可能
- PostgreSQLへTLS接続可能
- `employees` テーブルの作成・データ登録・参照が可能
- PHPからRDSのデータを取得してブラウザ表示可能

## 7. リソース削除

検証終了後に以下を実行した。

```bash
terraform destroy
```

実行結果：

```text
Destroy complete! Resources: 12 destroyed.
```

削除後にTerraform Stateを確認した。

```bash
terraform state list
```

管理対象リソースが残っていないことを確認した。

最後に再度以下を実行した。

```bash
terraform plan
```

結果：

```text
Plan: 12 to add, 0 to change, 0 to destroy.
```

これにより、Terraformコードから同じAWSインフラを再構築できる状態であることを確認した。
