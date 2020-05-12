build:
	docker build -t ecomicro/ubuntu:18.04 .
run:
	docker run -d --rm \
	-v /Volumes/Source:/mnt/Source \
	-v ~/Desktop/work/config:/mnt/config \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-p 1022:22 ecomicro/ubuntu:18.04
