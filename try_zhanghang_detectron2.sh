#!/bin/bash
# usage:
#   bash try_zhanghang_detectron2.sh <config_file_name> <mode(optional)>
# e.g. bash try_zh_detectron2.sh kitti-faster-rcnn-nasfpn-101
config_path_placeholder=$1
mode=$2

if [ "$config_path_placeholder" == "" ]; then
    echo "wrong usage"
    exit 1
fi

# Ensure you install with the steps in ipynb
# https://github.com/facebookresearch/detectron2/tree/master/configs/PascalVOC-Detection
rm detectron2-ResNeSt/datasets/VOC2012
ln -s `pwd`/kitti-voc/VOC2012 detectron2-ResNeSt/datasets/VOC2012
cp lsi-faster-rcnn/data/kitti/lists/train_lsi.txt detectron2-ResNeSt/datasets/VOC2012/ImageSets/Main/trainval.txt
cp lsi-faster-rcnn/data/kitti/lists/val_lsi.txt detectron2-ResNeSt/datasets/VOC2012/ImageSets/Main/test.txt

# Only use a few test data
# head -n 1000 lsi-faster-rcnn/data/kitti/lists/train_lsi.txt > detectron2-ResNeSt/datasets/VOC2012/ImageSets/Main/trainval.txt
head -n 2064 lsi-faster-rcnn/data/kitti/lists/val_lsi.txt > detectron2-ResNeSt/datasets/VOC2012/ImageSets/Main/test.txt

if [ "$mode" == "eval-only" ]; then
    # Use trained model in case you just want to --eval-only
    cat detectron_model/$config_path_placeholder/detectron_model_* > detectron2-ResNeSt/output/$config_path_placeholder/model_final.pth
    (cd detectron2-ResNeSt/ && python3 tools/train_net.py --eval-only \
      --config-file configs/kitti/$config_path_placeholder.yaml MODEL.WEIGHTS output/$config_path_placeholder/model_final.pth)
elif [ "$mode" == "" ]; then
    rm detectron2-ResNeSt/output/$config_path_placeholder/*tfevents*
    rm detectron2-ResNeSt/output/$config_path_placeholder/log.txt
    rm detectron2-ResNeSt/output/$config_path_placeholder/*.pth
    (cd detectron2-ResNeSt/ && python3 tools/train_net.py \
      --config-file configs/kitti/$config_path_placeholder.yaml SOLVER.MAX_ITER 10000 OUTPUT_DIR output/$config_path_placeholder)
elif [ "$mode" == "resume" ]; then
    (cd detectron2-ResNeSt/ && python3 tools/train_net.py --resume \
      --config-file configs/kitti/$config_path_placeholder.yaml OUTPUT_DIR output/$config_path_placeholder MODEL.WEIGHTS output/$config_path_placeholder/model_final.pth)
else
    echo "wrong mode"
    exit 1
fi

# Store trained model, github doesn't like big binary file
rm detectron_model/$config_path_placeholder/* || mkdir detectron_model/$config_path_placeholder -p

cp detectron2-ResNeSt/output/$config_path_placeholder/model_final.pth detectron2-ResNeSt/output/model_final.pth

(cd detectron_model/$config_path_placeholder && split -b 50M ../../detectron2-ResNeSt/output/$config_path_placeholder/model_final.pth detectron_model_)

# Store tfevents and log
cp detectron2-ResNeSt/output/$config_path_placeholder/*tfevents* detectron_model/$config_path_placeholder/
cp detectron2-ResNeSt/output/$config_path_placeholder/log.txt detectron_model/$config_path_placeholder/
