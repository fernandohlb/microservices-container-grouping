FROM maven:3.8.6-openjdk-8 as build-maven

RUN apt-get update && apt-get install wget -y
WORKDIR /repos
RUN mkdir bin

#Build Carts
ARG NAME=carts
ARG TAG=0.4.8
ENV FILE=${TAG}.zip
ENV COMPLETE_FILE_NAME=${NAME}'-'${FILE}
ARG REPO_ROOT=https://github.com/microservices-demo/ \
    REPO_ARCHIVE_PATH=/archive/refs/tags/
ENV REPO=${REPO_ROOT}${NAME}${REPO_ARCHIVE_PATH}${FILE}
ENV SCRIPT_DIR=${NAME}'-'${TAG}'/'
ENV BIN_DIR='/repos/bin'   

RUN wget ${REPO} -O ${COMPLETE_FILE_NAME}
RUN unzip ${COMPLETE_FILE_NAME}
RUN mvn -f ${SCRIPT_DIR} -DskipTests package
RUN cp ${SCRIPT_DIR}/target/*.jar ${BIN_DIR}

#Build Orders
ARG NAME=orders
ARG TAG=0.4.7
ENV FILE=${TAG}.zip
ENV COMPLETE_FILE_NAME=${NAME}'-'${FILE}
ARG REPO_ROOT=https://github.com/microservices-demo/ \
    REPO_ARCHIVE_PATH=/archive/refs/tags/
ENV REPO=${REPO_ROOT}${NAME}${REPO_ARCHIVE_PATH}${FILE}
ENV SCRIPT_DIR=${NAME}'-'${TAG}'/'
ENV BIN_DIR='/repos/bin'   

RUN wget ${REPO} -O ${COMPLETE_FILE_NAME}
RUN unzip ${COMPLETE_FILE_NAME}
COPY application.properties ${SCRIPT_DIR}/src/main/resources
COPY OrdersConfigurationProperties.java ${SCRIPT_DIR}/src/main/java/works/weave/socks/orders/config
RUN mvn -f ${SCRIPT_DIR} -DskipTests package
RUN cp ${SCRIPT_DIR}/target/*.jar ${BIN_DIR}

#Build shipping
ARG NAME=shipping
ARG TAG=0.4.8
ENV FILE=${TAG}.zip
ENV COMPLETE_FILE_NAME=${NAME}'-'${FILE}
ARG REPO_ROOT=https://github.com/microservices-demo/ \
    REPO_ARCHIVE_PATH=/archive/refs/tags/
ENV REPO=${REPO_ROOT}${NAME}${REPO_ARCHIVE_PATH}${FILE}
ENV SCRIPT_DIR=${NAME}'-'${TAG}'/'
ENV BIN_DIR='/repos/bin'   

RUN wget ${REPO} -O ${COMPLETE_FILE_NAME}
RUN unzip ${COMPLETE_FILE_NAME}
RUN mvn -f ${SCRIPT_DIR} -DskipTests package
RUN cp ${SCRIPT_DIR}/target/*.jar ${BIN_DIR}

#Build queue
ARG NAME=queue-master
ARG TAG=0.3.1
ENV FILE=${TAG}.zip
ENV COMPLETE_FILE_NAME=${NAME}'-'${FILE}
ARG REPO_ROOT=https://github.com/microservices-demo/ \
    REPO_ARCHIVE_PATH=/archive/refs/tags/
ENV REPO=${REPO_ROOT}${NAME}${REPO_ARCHIVE_PATH}${FILE}
ENV SCRIPT_DIR=${NAME}'-'${TAG}'/'
ENV BIN_DIR='/repos/bin'   

RUN wget ${REPO} -O ${COMPLETE_FILE_NAME}
RUN unzip ${COMPLETE_FILE_NAME}
RUN mvn -f ${SCRIPT_DIR} -DskipTests package
RUN cp ${SCRIPT_DIR}/target/*.jar ${BIN_DIR}

#Build Golang Applications
FROM golang:1.7.6 as build-go
RUN apt-get update && apt-get install wget -y
RUN apt-get install git -y
RUN apt-get install unzip -y
RUN apt-get install --reinstall ca-certificates -y
RUN git config --global http.sslVerify false

RUN mkdir repos
RUN mkdir -p src/github.com/microservices-demo
#Build payment
ARG NAME=payment
ARG TAG=0.4.3
ENV FILE=${TAG}.zip
ENV COMPLETE_FILE_NAME=${NAME}'-'${FILE}
ARG REPO_ROOT=https://github.com/microservices-demo/ \
    REPO_ARCHIVE_PATH=/archive/refs/tags/
ENV REPO=${REPO_ROOT}${NAME}${REPO_ARCHIVE_PATH}${FILE}
ENV SCRIPT_DIR=${NAME}'-'${TAG}'/'
RUN echo ${REPO}
RUN cd /go/repos && wget ${REPO} -O ${COMPLETE_FILE_NAME} && unzip ${COMPLETE_FILE_NAME}
RUN cp /go/repos/${SCRIPT_DIR} -rf src/github.com/microservices-demo/${NAME}
RUN go get -u github.com/FiloSottile/gvt
RUN cd /go/src/github.com/microservices-demo/${NAME}/ && gvt restore
RUN cd /go/src/github.com/microservices-demo/${NAME}/cmd/${NAME}svc && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o ${NAME}
RUN cp /go/src/github.com/microservices-demo/${NAME}/cmd/${NAME}svc/${NAME} /go/bin

#Build catalogue
ARG NAME=catalogue
ARG TAG=0.3.5
ENV FILE=${TAG}.zip
ENV COMPLETE_FILE_NAME=${NAME}'-'${FILE}
ARG REPO_ROOT=https://github.com/microservices-demo/ \
    REPO_ARCHIVE_PATH=/archive/refs/tags/
ENV REPO=${REPO_ROOT}${NAME}${REPO_ARCHIVE_PATH}${FILE}
ENV SCRIPT_DIR=${NAME}'-'${TAG}'/'
RUN echo ${REPO}
RUN cd /go/repos && wget ${REPO} -O ${COMPLETE_FILE_NAME} && unzip ${COMPLETE_FILE_NAME}
RUN cp /go/repos/${SCRIPT_DIR} -rf src/github.com/microservices-demo/${NAME}
RUN go get -u github.com/FiloSottile/gvt
RUN cd /go/src/github.com/microservices-demo/${NAME}/ && gvt restore
RUN cd /go/src/github.com/microservices-demo/${NAME}/cmd/${NAME}svc && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o ${NAME}
RUN cp /go/src/github.com/microservices-demo/${NAME}/cmd/${NAME}svc/${NAME} /go/bin
RUN cp -R /go/src/github.com/microservices-demo/${NAME}/images/ /go/bin

#Build user
ARG NAME=user
ARG TAG=0.4.7
ENV FILE=${TAG}.zip
ENV COMPLETE_FILE_NAME=${NAME}'-'${FILE}
ARG REPO_ROOT=https://github.com/microservices-demo/ \
    REPO_ARCHIVE_PATH=/archive/refs/tags/
ENV REPO=${REPO_ROOT}${NAME}${REPO_ARCHIVE_PATH}${FILE}
ENV SCRIPT_DIR=${NAME}'-'${TAG}'/'
RUN echo ${REPO}
RUN cd /go/repos && wget ${REPO} -O ${COMPLETE_FILE_NAME} && unzip ${COMPLETE_FILE_NAME}
RUN cp /go/repos/${SCRIPT_DIR} -rf src/github.com/microservices-demo/${NAME}
RUN go get -v github.com/Masterminds/glide
RUN cd /go/src/github.com/microservices-demo/${NAME}/ && glide install
RUN cd /go/src/github.com/microservices-demo/${NAME}/ && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o ${NAME}
RUN cp /go/src/github.com/microservices-demo/${NAME}/${NAME} /go/bin

FROM node:6-alpine as build-front

#Build Front-End
ARG NAME=front-end
ARG TAG=0.3.12
ENV FILE=${TAG}.zip
ENV COMPLETE_FILE_NAME=${NAME}'-'${FILE}
ARG REPO_ROOT=https://github.com/microservices-demo/ \
    REPO_ARCHIVE_PATH=/archive/refs/tags/
ENV REPO=${REPO_ROOT}${NAME}${REPO_ARCHIVE_PATH}${FILE}
ENV SCRIPT_DIR=${NAME}'-'${TAG}'/'
ENV BIN_DIR='/repos/bin'   

RUN mkdir repos
RUN cd repos && wget ${REPO} -O ${COMPLETE_FILE_NAME} && unzip ${COMPLETE_FILE_NAME}
RUN cd repos/${SCRIPT_DIR} && npm install
RUN mv repos/${SCRIPT_DIR} repos/${NAME}
COPY endpoints.js /repos/${NAME}/api
COPY customer-orders.html /repos/${NAME}/public


FROM node:6-alpine
ENV NODE_ENV "production"
ENV HATEAOS localhost:8086
ENV USER_DATABASE mongodb
ENV MONGO_HOST user-db
ENV JAVA_OPTS "-Djava.security.egd=file:/dev/urandom"

#Instala o Java no container
RUN apk update && apk add openjdk8

#Instala o supervisord
# RUN apt-get install supervisor -y && \
#   mkdir -p /var/log/supervisor && \
#   mkdir -p /etc/supervisor/conf.d
# ADD supervisor.conf /etc/supervisor.conf

#Cria o diretório base do container
WORKDIR /usr/src/

#Copia os binários das aplicações para o diretorio base
COPY --from=build-maven /repos/bin /usr/src/bin/
COPY --from=build-go /go/bin /usr/src/bin/
COPY --from=build-go /go/bin/images /usr/src/images/
COPY --from=build-front /repos/front-end /usr/src/bin/front-end
COPY run-apps-all-in-one.sh /usr/src/scripts/

EXPOSE 80 8079-8087
#CMD ["supervisord", "-c", "/etc/supervisor.conf"]
CMD ["sh","scripts/run-apps-all-in-one.sh"]
#CMD sh
