# What this terraform needs to do

1. Create a KMS key in Account A.

2. Create a Secret in Secrets Manager using the KMS key you created in Account A in step 1.

3. Modify the RESOURCE_POLICY.json file.

4. Replace the principal with the ARN of the role you created in Account B.  It should resemble (`arn:aws:iam::account_b_number:role/your_role_name`)

5. Run this in Account A to create the resource policy for the secret.

```bash
aws secretsmanager put-resource-policy --profile "account a profile" --region "us-east-1" --secret-id secret_key_name_inaccount_a --resource-policy file://RESOURCE_POLICY.json
```

6. Run this in Account A to display the KMS key policy.  You'll be modifying this policy in a few steps in the UI.

```bash
aws kms get-key-policy --profile "account a profile" --region "us-east-1" --key-id arn:aws:kms:us-east-1:account_a_number:key/guid_of_key_in_account_a --policy-name default
```

7. Edit in the Account A UI, the KMS key policy for the KMS key you created above to include the policy below.  Add it to the end of the policy json array.  You can re-run step 6 to see that it was modified.

```bash
{
    "Sid": "AllowUseOfTheKey",
    "Effect": "Allow",
    "Principal": 
        {"AWS": "<arn of the IAM role you created in step 3 in Account B>"},
    "Action": [
        "kms:Decrypt",
        "kms:DescribeKey"
    ],
    "Resource": "<arn of the KMS key you created in step 1 in Account A>"
}
```