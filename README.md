# cs231n_project
Course project for cs231n (2020 Spring)

## Clone the repo

```
git clone --recurse-submodules https://github.com/lk-chen/cs231n_project.git
git submodule update && git submodule init
```

## Docker (ignore if you use colab)

* Install docker on your own machine : check online sources
* Install docker on GLinux : go/installdocker

### After Docker Installation

```
./build_docker.sh && ./run_docker.sh
```
### Copy files

```
sudo docker cp cs231pj:/workspace/setup.ipynb .
```

