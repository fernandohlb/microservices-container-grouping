echo 'Build all microservices'
BIN_DIR='/bin'

echo '##########CARTS MICROSERVICE##############'
NAME=carts
TAG=0.4.8
FILE=$TAG.zip
COMPLETE_FILE_NAME=$NAME'-'$FILE
REPO=https://github.com/microservices-demo/$NAME/archive/refs/tags/$FILE
cd ../repos/
if [ -e "$COMPLETE_FILE_NAME" ] ; then
echo "The Cart Microservice was previously downloaded"
else
echo 'Downloading Microservice localy'
wget $REPO -O $COMPLETE_FILE_NAME
echo 'Unzip Microservice Folder'
unzip $COMPLETE_FILE_NAME
fi
SCRIPT_DIR=$NAME'-'$TAG'/'
echo 'Microservice Folder: ' $SCRIPT_DIR
echo 'Building Carts Microservice...'
mvn -f $SCRIPT_DIR -q -DskipTests package
echo 'Coping Binary to bin folder...'
cp $SCRIPT_DIR/target/*.jar ..$BIN_DIR

echo '##########ORDERS MICROSERVICE##############'
NAME=orders
TAG=0.4.7
FILE=$TAG.zip
COMPLETE_FILE_NAME=$NAME'-'$FILE
REPO=https://github.com/microservices-demo/$NAME/archive/refs/tags/$FILE
cd ../repos/
if [ -e "$COMPLETE_FILE_NAME" ] ; then
echo "The Orders Microservice was previously downloaded"
else
echo 'Downloading Microservice localy'
wget $REPO -O $COMPLETE_FILE_NAME
echo 'Unzip Microservice Folder'
unzip $COMPLETE_FILE_NAME
fi
SCRIPT_DIR=$NAME'-'$TAG'/'
echo 'Microservice Folder: ' $SCRIPT_DIR
echo 'Building Orders Microservice...'
mvn -f $SCRIPT_DIR -q -DskipTests package
echo 'Coping Binary to bin folder...'
cp $SCRIPT_DIR/target/*.jar ..$BIN_DIR

echo '##########SHIPPING MICROSERVICE##############'
NAME=shipping
TAG=0.4.8
FILE=$TAG.zip
COMPLETE_FILE_NAME=$NAME'-'$FILE
REPO=https://github.com/microservices-demo/$NAME/archive/refs/tags/$FILE
cd ../repos/
if [ -e "$COMPLETE_FILE_NAME" ] ; then
echo "The Shipping Microservice was previously downloaded"
else
echo 'Downloading Microservice localy'
wget $REPO -O $COMPLETE_FILE_NAME
echo 'Unzip Microservice Folder'
unzip $COMPLETE_FILE_NAME
fi
SCRIPT_DIR=$NAME'-'$TAG'/'
echo 'Microservice Folder: ' $SCRIPT_DIR
echo 'Building Shipping Microservice...'
mvn -f $SCRIPT_DIR -q -DskipTests package
echo 'Coping Binary to bin folder...'
cp $SCRIPT_DIR/target/*.jar ..$BIN_DIR

echo '##########QUEUE MICROSERVICE##############'
NAME=queue-master
TAG=0.3.1
FILE=$TAG.zip
COMPLETE_FILE_NAME=$NAME'-'$FILE
REPO=https://github.com/microservices-demo/$NAME/archive/refs/tags/$FILE
cd ../repos/
if [ -e "$COMPLETE_FILE_NAME" ] ; then
echo "The Queue Microservice was previously downloaded"
else
echo 'Downloading Microservice localy'
wget $REPO -O $COMPLETE_FILE_NAME
echo 'Unzip Microservice Folder'
unzip $COMPLETE_FILE_NAME
fi
SCRIPT_DIR=$NAME'-'$TAG'/'
echo 'Microservice Folder: ' $SCRIPT_DIR
echo 'Building Queue Microservice...'
mvn -f $SCRIPT_DIR -q -DskipTests package
echo 'Coping Binary to bin folder...'
cp $SCRIPT_DIR/target/*.jar ..$BIN_DIR

echo '##########PAYMENT MICROSERVICE##############'
SCRIPT_DIR='github.com/microservices-demo/payment'
echo 'Microservice Folder: ' $SCRIPT_DIR
echo 'Copying Microservice Folder to GOPATH'
go get -u $SCRIPT_DIR
echo 'Restore Dependencies'
cd $GOPATH/src/github.com/microservices-demo/payment/
go get -u github.com/FiloSottile/gvt
$GOPATH/bin/gvt restore
echo 'Building Native Go Microservice...'
cd $GOPATH/src/github.com/microservices-demo/payment/cmd/paymentsvc/
go build -o payment
chmod +x payment
echo 'Coping Bynary to bin folder...'
echo $HOME
cp payment $HOME/Documentos/Dev/microservices-container-grouping/$BIN_DIR
cd $HOME/Documentos/Dev/microservices-container-grouping/scripts/

echo '##########CATALOGUE MICROSERVICE##############'
SCRIPT_DIR='github.com/microservices-demo/catalogue'
echo 'Microservice Folder: ' $SCRIPT_DIR
echo 'Copying Microservice Folder to GOPATH'
go get -u $SCRIPT_DIR
echo 'Restore Dependencies'
cd $GOPATH/src/github.com/microservices-demo/catalogue/
go get -u github.com/FiloSottile/gvt
$GOPATH/bin/gvt restore
echo 'Building Native Go Microservice...'
cd $GOPATH/src/github.com/microservices-demo/catalogue/cmd/cataloguesvc/
go build -o catalogue
chmod +x catalogue
echo 'Coping Bynary to bin folder...'
echo $HOME
cp catalogue $HOME/Documentos/Dev/microservices-container-grouping/$BIN_DIR
echo 'Coping image folder to bin folder'
cd $GOPATH/src/github.com/microservices-demo/catalogue/
cp -R images/ $HOME/Documentos/Dev/microservices-container-grouping/$BIN_DIR
cd $HOME/Documentos/Dev/microservices-container-grouping/scripts/

echo '##########USER MICROSERVICE##############'
SCRIPT_DIR='github.com/microservices-demo/user'
echo 'Microservice Folder: ' $SCRIPT_DIR
echo 'Copying Microservice Folder to GOPATH'
go get -u $SCRIPT_DIR
echo 'Restore Dependencies'
go get -v github.com/Masterminds/glide
cd $GOPATH/src/github.com/microservices-demo/user/
$GOPATH/bin/glide install
echo 'Building Native Go Microservice...'
go install
cd $GOPATH/bin/
chmod +x user
echo 'Coping Bynary to bin folder...'
cp user $HOME/Documentos/Dev/microservices-container-grouping/$BIN_DIR
# echo $HOME
# cp user $HOME/Documentos/Dev/microservices-container-grouping/$BIN_DIR
cd $HOME/Documentos/Dev/microservices-container-grouping/scripts/