from interval_clustering.KMeans import k_means_interval
import pandas as pd
import os

max_unchanged_iterations = 20
for number_of_cluster in range(10, 11):

    for m in range(12):
        path = './data/load_data_normalized/%d_lower.csv' % (m + 1)
        lower = pd.read_csv(path, header=None)
        lower = lower.values

        path = './data/load_data_normalized/%d_upper.csv' % (m + 1)
        upper = pd.read_csv(path, header=None)
        upper = upper.values

        cluster = k_means_interval(lower, upper, number_of_cluster, max_unchanged_iterations)

        path = './clusters/euclidean/%d_%d.csv' % (m + 1, number_of_cluster)
        pd.DataFrame(cluster).to_csv(path, header=None, index=False)

        # break
