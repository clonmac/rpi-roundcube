VERSION=1.3.0

build:
	sudo docker build --build-arg version=$(VERSION) -t ymettier/rpi-roundcube:$(VERSION) .

run:
	sudo docker run -it --rm -p 8080:80 ymettier/rpi-roundcube:$(VERSION)

docker-shell:
	sudo docker run -it --rm -p 8080:80 ymettier/rpi-roundcube:$(VERSION) bash

clean:
	sudo docker rmi ymettier/rpi-roundcube:$(VERSION)
