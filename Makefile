
# Checks required environment variables
-include env.check.mk

# You must always use the Horizon name for architecture (`hzn architecture`)
export ARCH ?= $(shell hzn architecture)

# build, push, publish service all
publish-all: publish-app-mqtt publish-app-rest

publish-app-mqtt:
	make -C src/mqtt
	make -C src/mqtt push
	make -C src/mqtt publish-service
	make -C src/cam
	make -C src/cam push
	make -C src/cam publish-service
	make -C src/yolo
	make -C src/yolo push
	make -C src/yolo publish-service
	make -C src/appmqtt
	make -C src/appmqtt push
	make -C src/appmqtt publish-service
	make -C src/watcher
	make -C src/watcher push
	make -C src/watcher publish-service

publish-app-rest:
	make -C src/restcam
	make -C src/restcam push
	make -C src/restcam publish-service
	make -C src/yolov3
	make -C src/yolov3 push
	make -C src/yolov3 publish-service
	make -C src/watcher2
	make -C src/watcher2 push
	make -C src/watcher2 publish-service
	make -C src/apprest
	make -C src/apprest push
	make -C src/apprest publish-service
#	make -C src/yologpu
#	make -C src/yologpu push
#	make -C src/yologpu publish-service

publish-pattern: publish-pattern-appmqtt publish-pattern-apprest

publish-pattern-appmqtt:
	hzn exchange pattern publish -f pattern/pattern-appmqtt-yolo-arch.json

publish-pattern-apprest:
	hzn exchange pattern publish -f pattern/pattern-apprest-yolo-arch.json

# add all policies 
add-business-policy: add-business-policy-appmqtt add-business-policy-apprest

add-business-policy-appmqtt:
	make -C src/cam add-business-policy
	make -C src/yolo add-business-policy
	make -C src/watcher add-business-policy
	make -C src/appmqtt add-business-policy

add-business-policy-apprest:
	make -C src/restcam add-business-policy
	make -C src/yolov3 add-business-policy
	make -C src/watcher2 add-business-policy
	make -C src/apprest add-business-policy

