import argparse
import collections

parser = argparse.ArgumentParser(description='Parse arguments to do classes counting.')
parser.add_argument('--data_set_dir', type=str, help='Directory of the kitti training dataset, expecting image_2, label_2 as subdirectory.')

args = parser.parse_args()
data_set_dir = args.data_set_dir

if not data_set_dir:
    parser.error('data_set_dir need to be the directory for kitti training dataset')

num_per_class = collections.defaultdict(int)

for i in range(50000):
    try:
        file_name = '{}/label_2/{:06d}.txt'.format(data_set_dir,i)
        if i % 500 == 0:
            print(file_name)
        f = open(file_name, 'r')
        for l in f.readlines():
            c = l.split(' ')[0]
            num_per_class[c] += 1
    except:
        pass
print(num_per_class)
