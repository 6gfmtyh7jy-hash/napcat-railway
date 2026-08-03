FROM ubuntu:22.04

# 1. 设置非交互模式并安装基础工具与无头 UI 依赖
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    jq \
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

# 2. 从官方源直接拉取 NapCat 安装脚本，强制全静默执行
WORKDIR /root
RUN curl -o install.sh https://fastly.jsdelivr.net/gh/NapCatQQ/NapCat-Installer@main/install.sh || \
    curl -o install.sh https://raw.githubusercontent.com/NapCatQQ/NapCat-Installer/main/install.sh
RUN chmod +x install.sh && bash install.sh --no-prompt --docker || true

# 3. 设置虚拟显示与无头环境变量
ENV DISPLAY=:99
ENV ELECTRON_ENABLE_LOGGING=true
ENV ELECTRON_DISABLE_SECURITY_WARNINGS=true

# 4. 建立 dbus 目录，启动虚拟显示，最后拉起 NapCat
CMD ["sh", "-c", "mkdir -p /var/run/dbus && dbus-daemon --config-file=/usr/share/dbus-1/system.conf --fork && Xvfb :99 -screen 0 1024x768x16 & sleep 3 && (napcat --no-gui || node /root/NapCat/napcat.js --no-gui)"]
