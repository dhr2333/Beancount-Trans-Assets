FROM python:3.12-slim AS builder

WORKDIR /app
COPY requirements.txt .
RUN python -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir --upgrade pip && \
    /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

FROM python:3.12-slim
ENV BEANCOUNT_FILE=""
ENV FAVA_OPTIONS="-H 0.0.0.0 -p 5000"
ENV PATH="/opt/venv/bin:$PATH"
COPY --from=builder /opt/venv /opt/venv
EXPOSE 5000
CMD ["sh", "-c", "fava ${FAVA_OPTIONS} ${BEANCOUNT_FILE}"]