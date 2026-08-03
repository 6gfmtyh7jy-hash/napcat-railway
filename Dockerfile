# 1. 使用官方 Node.js 基础镜像（自带 npms 与 node 环境，且稳定开放）
FROM node:20-slim

# 2. 安装 DBus、Xvfb 以及 Electron 渲染所需的无头系统库
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    xvfb \
    dbus \
    x11-utils \
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

# 3. 通过 npm 全局安装 NapCatQQ（官方最纯粹的安装方式）
RUN npm install -g napcat@latest

# 4. 配置显示与无头环境变量
ENV DISPLAY=:99
ENV ELECTRON_ENABLE_LOGGING=true
ENV ELECTRON_DISABLE_SECURITY_WARNINGS=true

# 5. 自动创建 dbus 目录，启动虚拟显示，然后直接运行 napcat
CMD ["sh", "-c", "mkdir -p /var/run/dbus && dbus-daemon --config-file=/usr/share/dbus-1/system.conf --fork && Xvfb :99 -screen 0 1024x768x16 & sleep 3 && napcat --no-gui"]
