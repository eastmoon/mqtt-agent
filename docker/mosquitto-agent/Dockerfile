FROM nginx

# Install common tools
RUN \
    apt-get update -y && \
    apt-get install -y --no-install-recommends \
        perl \
        build-essential \
        curl \
        fcgiwrap

RUN \
    apt-get update -y && \
    apt-get install -y \
        mosquitto-clients

# Install JSON parser
RUN echo yes | cpan -i JSON

# Install switch module
RUN echo yes | cpan -i Switch

# Install c++ library dependency
ADD ./fcgiwrap /etc/init.d/fcgiwrap
ADD ./99-start-fcgiwrap.sh /docker-entrypoint.d/99-start-fcgiwrap.sh

# Inculde nginx configuration
ADD ./default.conf /etc/nginx/conf.d/default.conf

# Install mosquitto register
ADD ./98-start-mosquitto-job-register.sh /docker-entrypoint.d/98-start-mosquitto-job-register.sh
ADD ./mosquitto-job-register.sh /root/mosquitto-job-register.sh
