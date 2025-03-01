#--- Build ---
FROM ctfd/ctfd:3.4.1
WORKDIR /opt/CTFd

USER root

# hadolint ignore=DL3008
RUN sed -i "s/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list && \
  sed -i "s/security.debian.org/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list && \
  apt-get update \
  && apt-get install -y --no-install-recommends \
  build-essential \
  libffi-dev \
  libssl-dev \
  git \
  mariadb-client \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  && curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
  && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://mirrors.aliyun.com/docker-ce/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
  && apt-get update && apt-get install -y --no-install-recommends docker-ce docker-ce-cli containerd.io \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
  pip install --upgrade pip && \
  pip install -r requirements.txt

COPY ./CTFd /opt/CTFd/CTFd

RUN for d in CTFd/plugins/*; do \
  if [ -f "$d/requirements.txt" ]; then \
  pip install -r $d/requirements.txt --no-cache-dir; \
  fi; \
  done;

EXPOSE 8000
ENTRYPOINT /opt/CTFd/docker-entrypoint.sh