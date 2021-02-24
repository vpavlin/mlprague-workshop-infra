



all: deploy

project:
	oc project opendatahub

deploy: project
	bash deploy.sh

clean-users: project
	bash clean-users.sh
