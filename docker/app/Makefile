.PHONY: build_all push_all

USER = etosamoe

build_all: build_crawler \
			build_ui

build_crawler: crawler
	docker build -t $(USER)/crawler:latest crawler

build_ui: build_ui
	docker build -t $(USER)/ui:latest ui

push_all: push_crawler \
			push_ui

push_crawler: build_crawler
	docker push $(USER)/crawler:latest

push_ui: build_ui
	docker push $(USER)/ui:latest
