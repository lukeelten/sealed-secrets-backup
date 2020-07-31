# Sealed Secrets Backup

This software creates backups of the encryption keys used by [Bitnami Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets).
The backup is encrypted using a public-private key method and then uploaded to an s3 bucket.


## Create Encryption Key

```bash
openssl genrsa -out key.pem 4096
openssl rsa -in key.pem -pubout > key.pub
```