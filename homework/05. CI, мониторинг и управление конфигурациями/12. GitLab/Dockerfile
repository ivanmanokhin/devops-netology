FROM centos:7

ARG PYTHON_VERSION=3.9.16

RUN yum update -y \
    && yum install -y \
       gcc \
       openssl-devel \
       bzip2-devel \
       libffi-devel \
       zlib-devel \
       wget \
       make \
    && yum clean all \
    && rm -rf /var/cache

RUN wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \
    && tar -xzf Python-${PYTHON_VERSION}.tgz \
    && cd Python-${PYTHON_VERSION} \
    && ./configure --enable-optimizations \
    && make install \
    && cd .. \
    && rm -rf Python-${PYTHON_VERSION}*

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt \
    && rm requirements.txt

RUN mkdir /python-api
WORKDIR /python-api
COPY app.py app.py

EXPOSE 5290

CMD ["python3", "app.py"]
