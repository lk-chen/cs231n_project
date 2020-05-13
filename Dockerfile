FROM pytorch/pytorch:1.5-cuda10.1-cudnn7-runtime
RUN pip install jupyter
COPY *.ipynb ./
RUN apt update
RUN apt install wget unzip pv -y
RUN wget --progress=bar:force https://s3.eu-central-1.amazonaws.com/avg-kitti/data_object_image_2.zip
RUN wget --progress=bar:force https://s3.eu-central-1.amazonaws.com/avg-kitti/data_object_image_3.zip
RUN wget --progress=bar:force https://s3.eu-central-1.amazonaws.com/avg-kitti/data_object_label_2.zip
RUN unzip data_object_image_2.zip | pv -l > /dev/null
RUN unzip data_object_image_3.zip | pv -l > /dev/null
RUN unzip data_object_label_2.zip | pv -l > /dev/null
EXPOSE 8899
CMD [ "jupyter", "notebook", "--port=8899", "--ip=0.0.0.0", "--allow-root" ]
