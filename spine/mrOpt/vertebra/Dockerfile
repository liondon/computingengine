FROM python:3.6.12-stretch
WORKDIR /app
COPY requirements.txt /app
RUN pip install -r requirements.txt

RUN mkdir /apptmp
RUN mkdir /app/utils
COPY utils/*.py /app/utils/
COPY app.py /app
COPY worker.py /app

CMD ["python","app.py"]

