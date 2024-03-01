# Use a base image that includes necessary tools
FROM ubuntu:latest

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    procps \
    util-linux \
    grep \
    && rm -rf /var/lib/apt/lists/*

# Copy your script into the image
COPY check_ptp_status.sh /check_ptp_status.sh

# Make sure the script is executable
RUN chmod +x /check_ptp_status.sh

# Command to run your script
CMD ["/check_ptp_status.sh"]
