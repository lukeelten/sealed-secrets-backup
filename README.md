# Sealed Secrets Backup

This software creates backups of the encryption keys used by [Bitnami Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets).
The backup is encrypted using a public-private key method and then uploaded to an s3 bucket.


# Usage

## Create Encryption Key

```bash
openssl genrsa -out key.pem 4096
openssl rsa -in key.pem -pubout > key.pub
```

## Deploy to OpenShift or kubernetes

Use the provided `deploy.yaml` to deploy a cronjob to your cluster which backups your secrets once a day.
Make sure to set the values in the secret `sealed-secrets-backup` correctly.
Deploy the cronjob into the same namespace as your sealed-secret controller is running.

## Decrypt Backup

Use the provided decryption script to decrypt the backup easily.
```bash
./decrypt.sh <keyfile> <archive>
```