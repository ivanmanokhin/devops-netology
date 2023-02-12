FROM centos:centos7
    
ARG ES_VERSION=8.6.1
    
RUN yum update -y \
  && yum install -y \
  wget \
  perl-Digest-SHA \
  && yum clean all \
  && rm -rf /var/cache
    
RUN useradd -d /elasticsearch -U elastic \
  && mkdir /var/lib/elasticsearch \
  && chown -R elastic: /var/lib/elasticsearch
    
USER elastic
WORKDIR /elasticsearch

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz \
  && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz.sha512 \
  && shasum -a 512 -c elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz.sha512 \
  && tar -xzf elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz \
  && mv elasticsearch-${ES_VERSION}/* . \
  && rm -rf elasticsearch-${ES_VERSION}*
    
RUN echo -e '\
node.name: netology_test\n\
xpack.security.enabled: false\n\
path.data: /var/lib/elasticsearch\n\
discovery.type: single-node\n\
http.host: 0.0.0.0\n\
' > /elasticsearch/config/elasticsearch.yml

EXPOSE 9200
EXPOSE 9300

CMD ["./bin/elasticsearch"]
