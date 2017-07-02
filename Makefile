VERSION=1.3.0
REV=$(shell git rev-parse --short HEAD)

build:
	docker build --build-arg version=$(VERSION) -t ymettier/rpi-roundcube:$(VERSION) .

run:
	docker run -it --rm -p 8080:80 ymettier/rpi-roundcube:$(VERSION)

docker-shell:
	docker run -it --rm -p 8080:80 ymettier/rpi-roundcube:$(VERSION) bash

push:
	docker login
	docker tag ymettier/rpi-roundcube:$(VERSION) ymettier/rpi-roundcube:latest
	docker tag ymettier/rpi-roundcube:$(VERSION) ymettier/rpi-roundcube:$(VERSION)-latest
	docker tag ymettier/rpi-roundcube:$(VERSION) ymettier/rpi-roundcube:$(VERSION)-$(REV)
	docker push ymettier/rpi-roundcube:$(VERSION)-$(REV)
	docker push ymettier/rpi-roundcube:$(VERSION)-latest
	docker push ymettier/rpi-roundcube:latest
	docker logout

clean:
	docker rmi ymettier/rpi-roundcube:$(VERSION)
