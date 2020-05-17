#!/bin/bash
# build binary with steps in ipynb
# create dirs
rm eval_kitti/build/data/object/label_2
mkdir eval_kitti/build/data/object/ -p
ln -s `pwd`/training/label_2 eval_kitti/build/data/object/label_2
mkdir eval_kitti/build/lists/ -p
cp detectron2-ResNeSt/datasets/VOC2012/ImageSets/Main/test.txt eval_kitti/build/lists/

(cd eval_kitti/build && ./evaluate_object exp1 test)
