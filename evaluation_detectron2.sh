#!/bin/bash
# build binary with steps in ipynb
# create dirs

kitti_label_path=/home/lizhe/datasets/kitti/training/label_2
tsinghua_label_path=/demo-mount/datasets/cyclist-kitti/training/label_2
label_output_path=eval_kitti/build/data/object/label_2

test_txt=detectron2-ResNeSt/datasets/VOC2012/ImageSets/Main/test.txt
tsinghua_valid_txt=detectron2-ResNeSt/datasets/tsinghua_cyclist/VOC2012/ImageSets/Main/valid.txt

dataset_label_path=$kitti_label_path
eval_txt_name=test
cyclist_only=''

if [ "$1" == "tsinghua" ]; then
    echo '--------------------------------'
    echo 'eval using tsinghua dataset'
    echo '--------------------------------'
    dataset_label_path=$tsinghua_label_path
    test_txt=$tsinghua_valid_txt
    eval_txt_name=valid
    cyclist_only=cyclist-only
fi

rm $label_output_path
mkdir eval_kitti/build/data/object/ -p
ln -s $dataset_label_path $label_output_path
mkdir eval_kitti/build/lists/ -p
cp $test_txt eval_kitti/build/lists/

eval_set=exp1    # exp1

mkdir -p  eval_kitti/build/results/$eval_set

echo eval results from
echo `stat eval_kitti/build/results/$eval_set/data | grep 'Access: 20'`
echo

(cd eval_kitti/build/ && ./evaluate_object $eval_set $eval_txt_name)
(cd eval_kitti/ && python2 parser.py $eval_set $cyclist_only)
