from IntervalClustering.KMeans import k_means_interval
import pandas as pd
import os

def mkdir(path):
    folder = os.path.exists(path)
    if not folder:
        os.makedirs(path)

common_path = '/Users/XKS/Desktop'
max_unchanged_iterations = 50
for number_of_cluster in range(2, 11):

    for m in range(12):
        path = common_path + '/load_data_normalized/%d_lower.csv' % (m + 1)
        lower = pd.read_csv(path, header=None)
        lower = lower.values

        path = common_path + '/load_data_normalized/%d_upper.csv' % (m + 1)
        upper = pd.read_csv(path, header=None)
        upper = upper.values

        cluster = k_means_interval(lower, upper, number_of_cluster, max_unchanged_iterations)

        path = common_path + '/clusters/%s' % (m + 1)
        mkdir(path)
        path = common_path + '/clusters/%s/%d.csv' % (m + 1, number_of_cluster)
        pd.DataFrame(cluster).to_csv(path, header=None, index=False)

        # break
