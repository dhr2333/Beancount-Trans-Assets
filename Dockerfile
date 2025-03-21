FROM python:3.13.2

ENV BEANCOUNT_FILE ""
ENV FAVA_OPTIONS "-H 0.0.0.0 -p 5000"

COPY requirements.txt .

RUN pip install -r requirements.txt

EXPOSE 5000

CMD fava $FAVA_OPTIONS $BEANCOUNT_FILE