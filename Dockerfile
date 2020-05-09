FROM pytorch/pytorch:1.5-cuda10.1-cudnn7-runtime
RUN pip install jupyter
COPY *.ipynb ./
RUN echo "TODO fetch dataset"
EXPOSE 8899
CMD [ "jupyter", "notebook", "--port=8899", "--ip=0.0.0.0", "--allow-root" ]
