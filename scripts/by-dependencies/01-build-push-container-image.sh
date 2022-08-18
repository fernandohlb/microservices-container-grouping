echo 'Build by-dependencies docker'
docker build -f Dockerfile -t buzatof/by-dependencies .
docker push buzatof/by-dependencies:latest

echo 'Build Front-End docker'
docker build -f Dockerfile-node -t buzatof/front-end .
docker push buzatof/front-end:latest