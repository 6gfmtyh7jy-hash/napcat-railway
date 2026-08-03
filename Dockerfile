FROM mlgrub/napcat-docker:latest

# 安装 DBus 和 Xvfb 虚拟显示服务，解决 Electron 缺失界面的崩溃问题
USER root
RUN apt-get update && apt-get install -y \
    dbus \
    xvfb \
    x11-utils \
    && rm -rf /var/lib/apt/lists/*

# 设置环境变量，强制 Electron 走无头模式和软件渲染
ENV DISPLAY=:99
ENV ELECTRON_ENABLE_LOGGING=true
ENV ELECTRON_DISABLE_SECURITY_WARNINGS=true
ENV CHROMIUM_FLAGS="--no-sandbox --disable-dev-shm-usage --disable-gpu --headless"

# 启动 DBus 和虚拟 X 窗口，然后拉起 NapCat
CMD ["sh", "-c", "dbus-daemon --system --fork && Xvfb :99 -screen 0 1024x768x16 & sleep 2 && node /opt/QQ/resources/app/loadNapCat.js"]
