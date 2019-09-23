# What this terraform needs to do

1. Create an EC2 IAM role in Account B

2. Modify the PERMISSIONS_POLICY.json file.

3. Replace the Secrets Manager resource with the ARN of the Secrets Manager key you created in Account A.  It should resemble(`arn:aws:secretsmanager:us-east-1:account_a_number:secret:your_secrets_manager_key`)

4. Replace the KMS resource with the ARN of the KMS key you created in Account A.  It should resemble(`arn:aws:kms:us-east-1:account_a_number:key/your_kms_key_guid`)

5. Run this in Account B to create the IAM Policy.

```bash
aws iam create-policy --profile "account b profile" --region "us-east-1" --policy-name SECRETS_MANAGER_PERMISSIONS_POLICY --policy-document file://PERMISSIONS_POLICY.json
```

6. Run this in Account B to associate the policy you created in step 5 to the role you created in step 1.

```bash 
aws iam attach-role-policy --profile "account b profile" --region "us-east-1" --role-name account_b_role_name --policy-arn arn:aws:iam::account_b_number:policy/SECRETS_MANAGER_PERMISSIONS_POLICY
```