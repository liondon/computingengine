FROM python:3.6-alpine
WORKDIR /app
COPY requirements.txt /app
RUN pip install -r requirements.txt


RUN mkdir /apptmp


#ENV PORT=5010

#ENV CAMRIE=http://172.17.0.1:5115/efference

RUN mkdir /app/brainUtils
RUN mkdir /app/mrOptRouter
COPY app.py         /app
COPY brainUtils/    /app/brainUtils
COPY mrOptRouter/   /app/mrOptRouter

CMD ["python","app.py"]
