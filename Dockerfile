FROM ubuntu:22.04

# 1. 禁用交互式提示，安装基础系统依赖与虚拟显示环境
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    jq \
    xvfb \
    dbus \
    x11-utils \
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

# 2. 运行 NapCat 官方 Linux 一键安装脚本
RUN curl -o install.sh https://nclatest.com/napcat/install.sh && \
    chmod +x install.sh && \
    bash install.sh --no-prompt || true

# 3. 设置虚拟显示与无头环境变量
ENV DISPLAY=:99
ENV ELECTRON_ENABLE_LOGGING=true
ENV ELECTRON_DISABLE_SECURITY_WARNINGS=true

# 4. 启动守护进程并拉起 NapCat
CMD ["sh", "-c", "dbus-daemon --system --fork && Xvfb :99 -screen 0 1024x768x16 & sleep 3 && napcat"]
