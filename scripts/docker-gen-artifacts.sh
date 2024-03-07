docker build -t pldi_ae_container .
docker run -id --name=pldi-ae -t pldi_container:latest
docker cp pldi-ae:/artifacts ./artifacts