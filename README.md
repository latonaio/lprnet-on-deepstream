# lprnet-on-deepstream
lprnet-on-deepstream は、DeepStream 上で LPRNet の AIモデル を動作させるマイクロサービスです。  

## 動作環境
- NVIDIA 
    - DeepStream
- LPRNet
- Docker
- TensorRT Runtime

## LPRNetについて
LPRNet は、画像内のナンバープレートの文字を認識し、カテゴリラベルを返すAIモデルです。  
LPRNet は、特徴抽出にResNet18を使用しており、混雑した場所でも正確に物体検出を行うことができます。

## 動作手順
### Dockerコンテナの起動
Makefile に記載された以下のコマンドにより、LPRNet の Dockerコンテナ を起動します。
```
docker-run: ## docker container の立ち上げ
	docker-compose up -d
```
### ストリーミングの開始
Makefile に記載された以下のコマンドにより、DeepStream 上の LPRNet でストリーミングを開始します。  
```
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
```
## 相互依存関係にあるマイクロサービス  
本マイクロサービスを実行するために LPRNet の AIモデルを最適化する手順は、[lprnet-on-tao-toolkit](https://github.com/latonaio/lprnet-on-tao-toolkit)を参照してください。  


## engineファイルについて
engineファイルである lprnet_usa.engine は、[lprnet-on-tao-toolkit](https://github.com/latonaio/lprnet-on-tao-toolkit)と共通のファイルであり、当該レポジトリで作成した engineファイルを、本リポジトリで使用しています。  
