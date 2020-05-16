FROM pytorch/pytorch:1.5-cuda10.1-cudnn7-runtime
RUN pip install jupyter cython
COPY *.ipynb ./
RUN apt update
RUN apt install wget unzip pv g++ -y
COPY faster-rcnn.pytorch ./faster-rcnn.pytorch
RUN pip install -r faster-rcnn.pytorch/requirements.txt
EXPOSE 8899
CMD [ "jupyter", "notebook", "--port=8899", "--ip=0.0.0.0", "--allow-root" ]
