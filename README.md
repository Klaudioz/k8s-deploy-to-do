Clone the repo:
`git clone https://github.com/Klaudioz/do-kasten.git`

Move to the folder:
`cd do-kasten`

Build the container:
`docker build -t do-kasten .`

Run the container:
`docker run --rm -it --env DIGITALOCEAN_ACCESS_TOKEN=<your_token> do-kasten init_k10`

To clean the cluster use:
`docker run --rm -it --env DIGITALOCEAN_ACCESS_TOKEN=<your_token> do-kasten clean_k10`
