FROM mlikiowa/napcat-docker:latest

RUN apt update && apt install -y xvfb dbus-x11

RUN echo '#!/bin/bash' > /start.sh \
&& echo 'dbus-daemon --session --fork --print-address' >> /start.sh \
&& echo 'Xvfb :99 -screen 0 1280x720x16 &' >> /start.sh \
&& echo 'export DISPLAY=:99' >> /start.sh \
&& echo 'export LIBGL_ALWAYS_SOFTWARE=1' >> /start.sh \
&& echo 'export ELECTRON_DISABLE_GPU=1' >> /start.sh \
&& echo 'exec /app/entrypoint.sh' >> /start.sh

RUN chmod +x /start.sh
CMD ["/start.sh"]
