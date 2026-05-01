FROM python:3.9-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install common tools and build deps
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        sudo vim git zip tree curl wget ca-certificates build-essential gcc libpq-dev \
    && rm -rf /var/lib/apt/lists/*

ARG USERNAME=theia
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

# Create the user with passwordless sudo privileges (be resilient if group exists)
RUN groupadd --gid ${USER_GID} ${USERNAME} 2>/dev/null || true \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} -s /bin/bash \
    && usermod -aG sudo ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

WORKDIR /project

# Make sure pip and wheel are modern
RUN pip install --upgrade pip wheel

ENV TERM=xterm-256color
EXPOSE 8000

# Use non-root user for development
USER ${USERNAME}
