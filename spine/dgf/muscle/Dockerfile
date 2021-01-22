FROM python:3.6-slim

LABEL maintainer="Dr. Eros Montin, PhD <eros.montin@gmail.com>"


#install needed tool
RUN apt-get update && apt-get install -y --no-install-recommends wine wine64
RUN apt-get install -q -y --no-install-recommends \
	  xorg \
      unzip \
      wget \
      curl && \
    apt-get clean 
    


# Download the MCR from MathWorks site an install with -mode silent
RUN mkdir /mcr-install && \
    mkdir /opt/mcr && \
    cd /mcr-install && \
    wget --no-check-certificate -q https://ssd.mathworks.com/supportfiles/downloads/R2019a/Release/8/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2019a_Update_8_glnxa64.zip && \
    unzip -q MATLAB_Runtime_R2019a_Update_8_glnxa64 && \
    rm -f MATLAB_Runtime_R2019a_Update_8_glnxa64 && \
    ./install -destinationFolder /opt/mcr -agreeToLicense yes -mode silent && \
    cd / && \
    rm -rf mcr-install

RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y wine32




COPY requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt



# Configure environment variables for MCR
ENV LD_LIBRARY_PATH /opt/mcr/v96/runtime/glnxa64:/opt/mcr/v96/bin/glnxa64:/opt/mcr/v96/sys/os/glnxa64:/opt/mcr/v96/extern/bin/glnxa64
                    
ENV XAPPLRESDIR /etc/X11/app-defaults



RUN mkdir /apptmp

COPY ./celery /celery_tasks
COPY ./code/code/ /celery_tasks/
WORKDIR /celery_tasks

ENTRYPOINT celery -A tasks worker --loglevel=info
