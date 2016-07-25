REPO=quay.io/jcmoraisjr/jenkins-agent
TAG=0.1
build:
	docker build --tag=$(REPO):$(TAG) .
run:
	@[ -n "$(IP)" ] || (echo "Use: make run IP=<masterIP>"; exit 1;)
	docker run -d -e TZ="America/Sao_Paulo" -e MASTER_HOST=$(IP) $(REPO):$(TAG)
push:
	docker tag $(REPO):$(TAG) $(REPO):latest
	docker push $(REPO):$(TAG)
	docker push $(REPO):latest
