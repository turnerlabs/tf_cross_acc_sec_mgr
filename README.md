# The manual steps to get cross account access to secrets manager working(terraform option in the works)

This was created based on this web page(<https://aws.amazon.com/blogs/security/how-to-access-secrets-across-aws-accounts-by-attaching-resource-based-policies/)>

__Account A is the account where your Secrets Manager Key is stored.__

__Account B is the account trying to access the Secrets Manager key in Account A.__

1. Create a KMS key in Account A.  I'd suggest clicking the rotate yearly checkbox but you need to be prepared to possibly change things when the rotation occurs.

2. Create a Secret in Secrets Manager using the KMS key you created in Account A in step 1.  I'd also suggest rotating the secrets you store here as well.  Here's a good link on doing this:  <https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotating-secrets-lambda-function-customizing.html>

3. Create a new EC2 IAM role or use an existing EC2 IAM role in Account B.

4. Modify the RESOURCE_POLICY.json file.

5. Replace the principal with the ARN of the role you created in Account B in step 3.  It should resemble (`arn:aws:iam::account_b_number:role/your_role_name`)

6. Run this in Account A to create the resource policy for the secret.

    ```bash
    aws secretsmanager put-resource-policy --profile "account a profile" --region "us-east-1" --secret-id secret_key_name_inaccount_a --resource-policy file://RESOURCE_POLICY.json
    ```

7. Run this in Account A to display the KMS key policy.  You'll be modifying this policy in a few steps in the UI.

    ```bash
    aws kms get-key-policy --profile "account a profile" --region "us-east-1" --key-id arn:aws:kms:us-east-1:account_a_number:key/guid_of_key_in_account_a --policy-name default
    ```

8. Edit in the Account A UI, the KMS key policy for the KMS key you created above to include the policy below.  Add it to the end of the policy json array.  You can re-run step 7 to see that it was modified.

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

9. Modify the PERMISSIONS_POLICY.json file.

10. Replace the Secrets Manager resource with the ARN of the Secrets Manager key you created in Account A.  It should resemble(`arn:aws:secretsmanager:us-east-1:account_a_number:secret:your_secrets_manager_key`)

11. Replace the KMS resource with the ARN of the KMS key you created in Account A.  It should resemble(`arn:aws:kms:us-east-1:account_a_number:key/your_kms_key_guid`)

12. Run this in Account B to create the IAM Policy.

    ```bash
    aws iam create-policy --profile "account b profile" --region "us-east-1" --policy-name SECRETS_MANAGER_PERMISSIONS_POLICY --policy-document file://PERMISSIONS_POLICY.json
    ```

13. Run this in Account B to associate the policy you created in step 12 to the role you created in step 3.

    ```bash 
    aws iam attach-role-policy --profile "account b profile" --region "us-east-1" --role-name account_b_role_name --policy-arn arn:aws:iam::account_b_number:policy/SECRETS_MANAGER_PERMISSIONS_POLICY
    ```

## To test

1. Create an EC2 instance in Account B using the IAM Role you created in step 3.  I used the AWS Linux AMI to simplify things(you don't have to install the aws cli)

2. Connect via ssh to the instance.

3. Run the following command.

    ```bash
    aws secretsmanager get-secret-value --region "us-east-1" --secret-id arn:aws:secretsmanager:us-east-1:account_a_number:secret:secret_key_in_account_a --version-stage AWSCURRENT
    ```

4. Verify secret is correct.
