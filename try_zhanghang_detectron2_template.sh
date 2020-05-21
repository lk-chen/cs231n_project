#!/bin/bash
# Ensure you install with the steps in ipynb
# https://github.com/facebookresearch/detectron2/tree/master/configs/PascalVOC-Detection
rm detectron2-ResNeSt/datasets/VOC2012
ln -s `pwd`/kitti-voc/VOC2012 detectron2-ResNeSt/datasets/VOC2012
cp lsi-faster-rcnn/data/kitti/lists/train_lsi.txt detectron2-ResNeSt/datasets/VOC2012/ImageSets/Main/trainval.txt
cp lsi-faster-rcnn/data/kitti/lists/val_lsi.txt detectron2-ResNeSt/datasets/VOC2012/ImageSets/Main/test.txt

# Only use a few test data
# head -n 1000 lsi-faster-rcnn/data/kitti/lists/train_lsi.txt > detectron2-ResNeSt/datasets/VOC2012/ImageSets/Main/trainval.txt
head -n 2064 lsi-faster-rcnn/data/kitti/lists/val_lsi.txt > detectron2-ResNeSt/datasets/VOC2012/ImageSets/Main/test.txt

# Use trained model in case you just want to --eval-only
cat detectron_model/config_path_placeholder/detectron_model_* > detectron2-ResNeSt/output/model_final.pth

rm detectron2-ResNeSt/output/*tfevents*
(cd detectron2-ResNeSt/ && python3 tools/train_net.py \
  --config-file configs/kitti/config_path_placeholder.yaml)

# (cd detectron2-ResNeSt/ && python3 tools/train_net.py --eval-only \
#   --config-file configs/kitti/config_path_placeholder.yaml MODEL.WEIGHTS output/model_final.pth)

# Store trained model, github doesn't like big binary file
rm detectron_model/config_path_placeholder/* || mkdir detectron_model/config_path_placeholder -p
(cd detectron_model/config_path_placeholder && split -b 50M ../../detectron2-ResNeSt/output/model_final.pth detectron_model_)
