 (docker operations may require sudo on linux)

 ctrl + d to exit

`docker build -t pldi_ae_container .`

`docker run -id --name=pldi-ae -t pldi_container:latest`

`docker cp pldi-ae:/artifacts ./artifacts`

`docker exec -it pldi-ae bash`

cleanup:

`docker stop pldi-ae`
`docker rm pldi-ae`

