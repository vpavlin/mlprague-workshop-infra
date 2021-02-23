



all: deploy

deploy:
	oc project opendatahub
	bash deploy.sh