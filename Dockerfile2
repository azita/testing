FROM python:3.8-slim

WORKDIR /app

# Install Kubernetes client library
RUN pip install kubernetes asyncio

# Copy the script into the container
COPY ptp_watch.py .

CMD ["python", "/app/ptp_watch.py"]
