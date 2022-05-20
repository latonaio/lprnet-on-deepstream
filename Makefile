:# Self-Documented Makefile
# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

docker-build: ## docker image の作成
	bash docker-build.sh

docker-run: ## docker container の立ち上げ
	docker-compose up -d

docker-login: ## docker container にログイン
	docker exec -it deepstream-lprnet bash

stream-start: ## ストリーミングを開始する
	xhost +
	docker exec -it deepstream-lprnet cp /app/mnt/deepstream-lpr-app /app/src/deepstream_lpr_app/deepstream-lpr-app/
	docker exec -it deepstream-lprnet cp /app/mnt/lprnet_usa.engine /app/src/deepstream_lpr_app/models/LP/LPR/us_lprnet_baseline18_deployable.etlt_b16_gpu0_fp16.engine
	docker exec -it deepstream-lprnet cp /app/mnt/lpdnet_usa.engine /app/src/deepstream_lpr_app/models/LP/LPD/usa_pruned.etlt_b16_gpu0_fp16.engine
	docker exec -it deepstream-lprnet cp /app/mnt/trafficcamnet.engine /app/src/deepstream_lpr_app/models/tao_pretrained_models/trafficcamnet/resnet18_trafficcamnet_pruned.etlt_b1_gpu0_fp16.engine
	docker exec -it deepstream-lprnet cp /app/mnt/lpd_us_config.txt /app/src/deepstream_lpr_app/deepstream-lpr-app/lpd_us_config.txt
	docker exec -it deepstream-lprnet cp /app/mnt/trafficamnet_config.txt /app/src/deepstream_lpr_app/deepstream-lpr-app/trafficamnet_config.txt
	docker exec -it deepstream-lprnet cp /app/src/deepstream_lpr_app/deepstream-lpr-app/dict_us.txt /app/src/deepstream_lpr_app/deepstream-lpr-app/dict.txt
	docker exec -it -w /app/src/deepstream_lpr_app/deepstream-lpr-app deepstream-lprnet ./deepstream-lpr-app 1 3 0 /dev/video0 lpr
