FROM openjdk:8

ENV HATEAOS localhost:8086
ENV USER_DATABASE mongodb
ENV MONGO_HOST user-db
ENV JAVA_OPTS "-Djava.security.egd=file:/dev/urandom"

#Instala o supervisord
# RUN apt-get update && apt-get install supervisor -y && \
#   mkdir -p /var/log/supervisor && \
#   mkdir -p /etc/supervisor/conf.d
# ADD supervisor.conf /etc/supervisor.conf

#Instala o NodeJS para executar o Front-End
RUN apt-get update && apt-get install nodejs -y
RUN apt-get install npm -y

#Cria o diretório base do container
WORKDIR /usr/src/

#Copia os binários das aplicações para o diretorio base
COPY bin /usr/src/bin/
COPY bin/images /usr/src/images
COPY scripts/all-in-one/run-apps-all-in-one.sh /usr/src/scripts/

#Prepare Front-End for execution
WORKDIR /usr/src/bin/front-end/
RUN npm install

WORKDIR /usr/src/

#Copia a aplicação front-end para o diretorio de aplicações
#COPY ./front-end /usr/src/app/front-end
EXPOSE 80 8079-8086
CMD ["sh","scripts/run-apps-all-in-one.sh"]
