FROM ubuntu:latest

COPY ./scripts/* /usr/local/scripts/

RUN chmod +x /usr/local/scripts/* && /usr/local/scripts/mirror-helper.sh && /usr/local/scripts/setup-basic.sh
