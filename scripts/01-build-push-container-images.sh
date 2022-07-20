echo 'Build all-in-one docker'
docker build -f scripts/all-in-one/Dockerfile -t buzatof/all-in-one .
docker push buzatof/all-in-one:latest