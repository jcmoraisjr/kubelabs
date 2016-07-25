REPO=quay.io/jcmoraisjr/jdk
TAG=8
build:
	docker build --tag=$(REPO):$(TAG) --build-arg java=$(TAG) .
push:
	docker push $(REPO):$(TAG)
