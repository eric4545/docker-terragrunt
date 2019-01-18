# https://github.com/hashicorp/terraform/releases
ARG TERRAFORM_VERSION=0.11.11
FROM hashicorp/terraform:${TERRAFORM_VERSION}

# https://github.com/gruntwork-io/terragrunt/releases
ENV TERRAGRUNT_VERSION=0.17.4
ENV KUBECTL_VERSION=1.13.0
ENV HELM_VERSION=2.12.0

ENV GCLOUD_SDK_PATH=/opt/google-cloud-sdk
# https://cloud.google.com/sdk/docs/release-notes
ENV GCLOUD_SDK_VERSION=227.0.0
ENV CLOUDSDK_CORE_DISABLE_PROMPTS=1
ENV CLOUDSDK_PYTHON_SITEPACKAGES=0
ENV PATH=$PATH:/opt/google-cloud-sdk/bin

RUN apk add --no-cache \
        curl-dev \
        curl \
        bash \
        python \
        ca-certificates \
        jq \
        aws-cli \
    && \
    mkdir -p /tmp && \
    cd /tmp && \
    curl -sLo /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
        chmod +x /usr/local/bin/terragrunt && \
    curl -sLo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
        chmod +x /usr/local/bin/kubectl && \
    curl -sL https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar xz && \
        mv linux-amd64/helm /usr/local/bin/helm && \
        rm -rf linux-amd64 && \
    mkdir -p ${GCLOUD_SDK_PATH} && \
        curl -sL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz | tar xz && \
        mv google-cloud-sdk/ $GCLOUD_SDK_PATH/../ && \
        $GCLOUD_SDK_PATH/install.sh \
            --usage-reporting=false \
            --bash-completion=false \
            --disable-installation-options \
        && \
    rm -rf /tmp/* && \
    mkdir /deploy

WORKDIR /deploy

ENTRYPOINT [ "terragrunt" ]