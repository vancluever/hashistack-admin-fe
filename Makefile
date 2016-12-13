.PHONY: bin image push release clean

TAG=vancluever/hashistack-admin-fe

image:
	docker build --tag $(TAG):latest .

push: image
	docker push $(TAG):latest

release: push

clean:
	docker rmi -f $(TAG)
