FROM openjdk:8

ENV HATEAOS user
ENV USER_DATABASE mongodb
ENV MONGO_HOST user-db
ENV JAVA_OPTS "-Djava.security.egd=file:/dev/urandom"
#Instala o supervisord
# RUN apt-get update && apt-get install supervisor -y && \
#   mkdir -p /var/log/supervisor && \
#   mkdir -p /etc/supervisor/conf.d
# ADD supervisor.conf /etc/supervisor.conf

#Cria o diretório base do container
WORKDIR /usr/src/

#Copia os binários das aplicações para o diretorio base
COPY bin /usr/src/bin/
COPY bin/images /usr/src/images
COPY scripts/run-apps-all-in-one.sh /usr/src/scripts/

#Copia a aplicação front-end para o diretorio de aplicações
#COPY ./front-end /usr/src/app/front-end
EXPOSE 80 8080-8085
CMD ["sh","scripts/run-apps-all-in-one.sh"]
