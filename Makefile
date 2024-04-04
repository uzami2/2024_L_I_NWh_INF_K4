deps:
	pip install -r requirements.txt; \
	pip install -r test_requirements.txt	
lint:
	flake8 hello_world test
.PHONY: test
test:
	PYTHONPATH=. py.test --verbose -s
test_smoke:
	curl -s -o /dev/null -w "%{http_code}" -- fail 127.0.0.1:5000
run:
	python main.py
docker_build:
		docker build -t hello-world-printer .
docker_run: docker_build
		docker run \
	 	  --name hello-world-printer-dev \
		   -p 5000:5000 \
		   -d hello-world-printer
	if [[ $TRAVIS_TAG =~ ^[0-9]+\.[0-9]+.* ]]; then
	USERNAME=aleksanderbucze
	TAG=$(USERNAME)/hello-world-printer:$TRAVIS_TAG
docker_push: docker_build
	@docker login --username $(USERNAME) --password $${DOCKER_PASSWORD}; \
	docker tag hello-world-printer $(TAG); \
	docker push $(TAG); \
	docker logout;
	fi;
	