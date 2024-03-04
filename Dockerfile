FROM registry.k8s.io/node-problem-detector/node-problem-detector:v0.8.14 as builder

# Set default build architecture
ARG TARGETOS
ARG TARGETARCH
ENV BUILDX_ARCH="${TARGETOS:-linux}-${TARGETARCH:-amd64}"

# crictl version
ARG VERSION="v1.28.0"

# Install necessary tools including curl, jq, and unzip (needed for crictl installation)
# Keeping curl and jq for runtime use
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
    curl \
    jq \
    unzip && \
    # Download and install crictl
    curl -sLO https://github.com/kubernetes-sigs/cri-tools/releases/download/${VERSION}/crictl-${VERSION}-${BUILDX_ARCH}.tar.gz && \
    tar zxvf crictl-${VERSION}-${BUILDX_ARCH}.tar.gz -C /usr/bin && \
    rm -f crictl-${VERSION}-${BUILDX_ARCH}.tar.gz && \
    # Clean up unnecessary packages and files
    apt-get -qq -y autoremove && \
    apt-get -qq -y clean && \
    rm -rf /var/lib/apt/lists/*

# Install systemctl if necessary - Note: systemctl is typically not functional/required in container environments
RUN apt-get -qq install -y systemctl

# Assuming you are using a multi-stage build to keep your final image clean and minimal
FROM registry.k8s.io/node-problem-detector/node-problem-detector:v0.8.14

# Copy crictl from the builder stage
COPY --from=builder /usr/bin/crictl /usr/bin/crictl

# Copy curl and jq from the builder stage, if not available in the final image
# Note: This step is redundant if the final base image already includes curl and jq
COPY --from=builder /usr/bin/curl /usr/bin/curl
COPY --from=builder /usr/bin/jq /usr/bin/jq

