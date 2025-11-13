FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PORTACODE_GATEWAY=wss://portacode.com/gateway

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        gcc \
        libffi-dev \
        libssl-dev \
        pkg-config \
        sudo \
        git \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip && \
    pip install "portacode==1.3.38"

RUN useradd -m -s /bin/bash student && \
    echo "student ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /home/student

COPY entrypoint.sh /usr/local/bin/start-portacode.sh
RUN chmod +x /usr/local/bin/start-portacode.sh

ENV SERVICE_NAME=workshop-device

ENTRYPOINT ["/usr/local/bin/start-portacode.sh"]
