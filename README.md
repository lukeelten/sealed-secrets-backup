# Sealed Secrets Backup


## Create Encryption Key

```bash
openssl genrsa -out key.pem 4096
openssl rsa -in key.pem -pubout > key.pub
```