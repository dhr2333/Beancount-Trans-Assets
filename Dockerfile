FROM python:3.12-slim AS builder

# 构建加速：默认使用国内 PyPI 镜像（可通过 --build-arg PIP_INDEX_URL 覆盖）；
# BuildKit 缓存挂载让下载的 wheel 跨构建/重试复用，避免网络抖动导致整轮超时
ARG PIP_INDEX_URL=https://repo.huaweicloud.com/repository/pypi/simple/

ENV PIP_DEFAULT_TIMEOUT=6000 \
    PIP_RETRIES=5

WORKDIR /app
COPY requirements.txt .
RUN --mount=type=cache,target=/root/.cache/pip \
    python -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip -i ${PIP_INDEX_URL} && \
    /opt/venv/bin/pip install -r requirements.txt -i ${PIP_INDEX_URL}

FROM python:3.12-slim
ENV BEANCOUNT_FILE=""
ENV FAVA_OPTIONS="-H 0.0.0.0 -p 5000"
ENV PATH="/opt/venv/bin:$PATH"
COPY --from=builder /opt/venv /opt/venv
EXPOSE 5000
CMD ["sh", "-c", "fava ${FAVA_OPTIONS} ${BEANCOUNT_FILE}"]
