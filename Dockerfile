FROM nvcr.io/nvidia/deepstream-l4t:6.0.1-samples      
RUN mkdir -p /app/src /app/mnt
WORKDIR /app/src
RUN git clone https://github.com/NVIDIA-AI-IOT/deepstream_lpr_app.git
WORKDIR /app/src/deepstream_lpr_app
RUN bash download_us.sh


WORKDIR /app/src/deepstream_lpr_app/nvinfer_custom_lpr_parser
RUN make
CMD bash
