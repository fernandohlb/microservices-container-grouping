FROM openjdk:8

#Instala o supervisord
RUN apt-get update && apt-get install supervisor -y && \
  mkdir -p /var/log/supervisor && \
  mkdir -p /etc/supervisor/conf.d
ADD supervisor.conf /etc/supervisor.conf

#Cria o diretório base do container
WORKDIR /usr/src/

#Copia os binários das aplicações para o diretorio base
COPY ./bin /usr/src/

#Copia a aplicação front-end para o diretorio de aplicações
#COPY ./front-end /usr/src/app/front-end

EXPOSE 8080 8082
CMD ["supervisord", "-c", "/etc/supervisor.conf"]