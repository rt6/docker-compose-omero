build-base:
	docker build -t omero-base omero-base/
build-start:
	docker-compose up
delete-containers:
	docker rm omero-web omero-server omero-db omero-data
delete-images:
	docker rmi omero-db omero-data omero-web omero-server omero-base
start-containers:
	docker start omero-web omero-server omero-db omero-data
stop-containers:
	docker stop omero-web omero-server omero-db omero-data
status:
	docker ps -a

