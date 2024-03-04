FROM registry.k8s.io/node-problem-detector/node-problem-detector:v0.8.14 as builder

# Install crictl
ARG TARGETOS
ARG TARGETARCH
#`BUILDX_ARCH` will be used in the buildx package download URL
# The required format is in `TARGETOS-TARGETARCH`
# Set it default to linux-amd64 to make the Dockerfile
# works with / without buildkit
ENV BUILDX_ARCH="${TARGETOS:-linux}-${TARGETARCH:-amd64}"

ARG VERSION="v1.28.0"
RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qq -y curl unzip jq < /dev/null > /dev/null && \
    rm -rf /var/cache/apt/* && \
    curl -sLO https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-${VERSION}-${BUILDX_ARCH}.tar.gz && \
    tar zxvf crictl-$VERSION-${BUILDX_ARCH}.tar.gz -C /usr/bin && \
    rm -f crictl-$VERSION-${BUILDX_ARCH}.tar.gz && \
    apt-get -qq autoremove curl unzip
RUN apt-get -qq install systemctl

# Add your custom script to the image
COPY check_ptp_locked.sh /usr/local/bin/check_ptp_locked.sh

# Ensure your script is executable
RUN chmod +x /usr/local/bin/check_ptp_locked.sh
