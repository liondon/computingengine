FROM python:3.6-slim

LABEL maintainer="Dr. Eros Montin, PhD <eros.montin@gmail.com>"

#install needed tool
RUN apt-get update && apt-get install -y --no-install-recommends wine wine64
RUN apt-get update && apt-get install --fix-missing -q -y --no-install-recommends \
    xorg \
    unzip \
    wget \
    curl && \
    apt-get clean 

# Download the MCR from MathWorks site an install with -mode silent
RUN mkdir /mcr-install && \
    mkdir /opt/mcr && \
    cd /mcr-install && \
    wget -q http://ssd.mathworks.com/supportfiles/downloads/R2020a/Release/4/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2020a_Update_4_glnxa64.zip && \
    unzip -q MATLAB_Runtime_R2020a_Update_4_glnxa64.zip && \
    rm -f MATLAB_Runtime_R2020a_Update_4_glnxa64.zip && \
    ./install -destinationFolder /opt/mcr -agreeToLicense yes -mode silent && \
    cd / && \
    rm -rf mcr-install

RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y wine32




COPY requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt



# Configure environment variables for MCR
ENV LD_LIBRARY_PATH /opt/mcr/v98/runtime/glnxa64:/opt/mcr/v98/bin/glnxa64:/opt/mcr/v98/sys/os/glnxa64
ENV XAPPLRESDIR /opt/mcr/v98/X11/app-defaults

RUN mkdir /apptmp

COPY ./celery /celery_tasks
COPY ./code/pmr_code/ /celery_tasks
COPY ./code/acm_code/ /celery_tasks
COPY ./code/mr_code/ /celery_tasks
COPY ./code/di_code/ /celery_tasks
WORKDIR /celery_tasks

RUN chmod a+x /celery_tasks/DImat /celery_tasks/ACMCompiledtask /celery_tasks/MRtask /celery_tasks/PMRtask 

ENTRYPOINT celery -A tasks worker --loglevel=info
