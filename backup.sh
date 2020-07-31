#!/bin/bash
set -e

cert_file=${PUBLIC_KEY:-"/config/certificate.crt"}
if [[ ! -r "${cert_file}" ]]; then
    echo "No certificate found"
    exit 1
fi

if [[ -z "${AWS_ACCESS_KEY_ID}" || -z "${AWS_SECRET_ACCESS_KEY}" ]]; then
    echo "No AWS access key provided"
    exit 2
fi

target_bucket=${TARGET_BUCKET}
if [[ -z "${target_bucket}" ]]; then
    echo "Please specify a target S3 bucket"
    exit 3
fi

namespace=${NAMESPACE}
if [[ -z "${namespace}" ]]; then
    if [[ -r "/var/run/secrets/kubernetes.io/serviceaccount/namespace" ]]; then
        namespace=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)
    else 
        namespace="kube-system"
    fi
fi

# export secrets
export_file="secrets.json"
secrets=$(oc get secrets -n "${namespace}" --no-headers | grep 'kubernetes.io/tls' | awk '{print $1}' | grep -i 'sealed-.*' | xargs)
oc get secret -n "${namespace}" -o json ${secrets} > "${export_file}"

# encrypt
key="key.bin"
encrypted_key="key.enc"
encrypted_file="secrets.enc"


openssl rand -base64 128 > "${key}"
openssl rsautl -encrypt -inkey "${cert_file}" -pubin -in "${key}" -out "${encrypted_key}"
openssl enc -aes256 -salt -in "${export_file}" -out "${encrypted_file}" -pass "file:${key}" 

output="secret.enc.tar"
tar cf "${output}" "${encrypted_key}" "${encrypted_file}"


target_name=$(date '+%Y-%m-%d--%H-%M').tar
aws s3 cp "${encrypted_file}" "s3://${target_bucket}/${target_name}"

shred -u -z "${key}" "${output}" "${export_file}" "${encrypted_key}" "${encrypted_file}"