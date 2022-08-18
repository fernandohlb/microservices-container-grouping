echo 'Build all-in-one docker'
docker build -f Dockerfile -t buzatof/all-in-one .
docker push buzatof/all-in-one:latest

# echo 'Build by-stack-jvm docker'
# docker build -f by-stack/Dockerfile-jvm -t buzatof/by-stack-jvm .
# docker push buzatof/by-stack-jvm:latest

# echo 'Build by-stack-go docker'
# docker build -f by-stack/Dockerfile-go -t buzatof/by-stack-go .
# docker push buzatof/by-stack-go:latest

# echo 'Build by-stack-node docker'
# docker build -f by-stack/Dockerfile-node -t buzatof/by-stack-node .
# docker push buzatof/by-stack-node:latest