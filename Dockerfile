FROM mlikiowa/napcat-docker:latest

RUN echo '#!/bin/bash' > /start.sh \
&& echo 'mkdir -p /run/dbus' >> /start.sh \
&& echo 'dbus-daemon --system --fork --print-pid' >> /start.sh \
&& echo 'dbus-daemon --session --fork --print-address' >> /start.sh \
&& echo 'Xvfb :99 -screen 0 1280x720x16 &' >> /start.sh \
&& echo 'export DISPLAY=:99' >> /start.sh \
&& echo 'export LIBGL_ALWAYS_SOFTWARE=1' >> /start.sh \
&& echo 'export ELECTRON_DISABLE_GPU=1' >> /start.sh \
# 强制Electron完全关闭GPU硬件加速，根治EGL报错
&& echo 'export ELECTRON_EXTRA_LAUNCH_ARGS="--disable-gpu --disable-gpu-sandbox --headless"' >> /start.sh \
&& echo 'exec /app/entrypoint.sh' >> /start.sh

RUN chmod +x /start.sh
CMD ["/start.sh"]
