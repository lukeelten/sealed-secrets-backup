FROM quay.io/openshift/origin-cli:v3.11

ENV AWS_DEFAULT_REGION=eu-central-1
ENV AWS_ACCESS_KEY_ID= AWS_SECRET_ACCESS_KEY= PUBLIC_KEY= 

RUN yum -y install awscli && yum -y clean all

COPY backup.sh /

WORKDIR /tmp
ENTRYPOINT [ "/backup.sh" ]