FROM python:3.9-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install common tools and build deps
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        sudo vim git zip tree curl wget ca-certificates build-essential gcc libpq-dev docker.io docker-cli \
    && rm -rf /var/lib/apt/lists/*

ARG USERNAME=theia
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

# Create the user with passwordless sudo privileges (be resilient if group exists)
# The mounted Docker socket in this environment is owned by root:root, so the
# dev user must also be able to read/write through group 0.
RUN groupadd --gid ${USER_GID} ${USERNAME} 2>/dev/null || true \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} -s /bin/bash \
    && usermod -aG sudo ${USERNAME} \
    && usermod -aG docker ${USERNAME} \
    && usermod -aG root ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

WORKDIR /project

# Make sure pip, wheel, and uv are modern
RUN pip install --upgrade pip wheel uv

# Auto-activate the workspace virtualenv for new interactive shells when present.
RUN printf '%s\n' \
    'if [ -f "$HOME/venv/bin/activate" ]; then' \
    '  . "$HOME/venv/bin/activate"' \
    'fi' >> /home/${USERNAME}/.bashrc

ENV TERM=xterm-256color
EXPOSE 8000

# Use non-root user for development
USER ${USERNAME}
