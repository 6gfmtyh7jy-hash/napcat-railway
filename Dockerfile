FROM node:20-slim

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    xvfb \
    dbus \
    procps \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

# 下载 NapCatQQ 官方 GitHub 镜像源码包并解压
WORKDIR /app
RUN curl -L -o napcat.zip https://github.com/NapCatQQ/NapCatQQ/releases/latest/download/NapCat.linux.x64.zip || \
    curl -L -o napcat.zip https://nclatest.com/napcat/NapCat.linux.x64.zip
RUN unzip napcat.zip && rm napcat.zip

ENV DISPLAY=:99
ENV ELECTRON_ENABLE_LOGGING=true
ENV ELECTRON_DISABLE_SECURITY_WARNINGS=true

CMD ["sh", "-c", "mkdir -p /var/run/dbus && dbus-daemon --config-file=/usr/share/dbus-1/system.conf --fork && Xvfb :99 -screen 0 1024x768x16 & sleep 3 && node napcat.js --no-gui"]
