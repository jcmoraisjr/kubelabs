REPO=quay.io/jcmoraisjr/jenkins-master
TAG=1.651.3
build:
	docker build --tag=$(REPO):$(TAG) --build-arg=JENKINS_VER=$(TAG) .
run:
	docker run -d -p 8080:8080 -p 50000:50000 $(REPO):$(TAG)
push:
	docker tag $(REPO):$(TAG) $(REPO):latest
	docker push $(REPO):$(TAG)
	docker push $(REPO):latest
