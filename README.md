git clone https://github.com/Klaudioz/do-kasten.git
cd do-kasten
docker build -t do-kasten .
docker run --rm -it --env DIGITALOCEAN_ACCESS_TOKEN=<your_token> do-kasten init_k10

To clean the cluster use:

docker run --rm -it --env DIGITALOCEAN_ACCESS_TOKEN=<your_token> do-kasten clean_k10
