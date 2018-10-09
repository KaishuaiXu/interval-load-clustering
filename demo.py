from interval_clustering.KMeans import k_means_interval
import pandas as pd

max_unchanged_iterations = 20
for number_of_cluster in range(9, 10):

    for m in range(0, 1):
        path = './data/load_data_profiles/%d_lower.csv' % (m + 1)
        lower = pd.read_csv(path, header=None)
        lower = lower.values

        path = './data/load_data_profiles/%d_upper.csv' % (m + 1)
        upper = pd.read_csv(path, header=None)
        upper = upper.values

        minimum = 9999999
        best_cluster = []

        for times in range(100):
            print('Times: %d' % (times + 1))
            cluster, total_dist = k_means_interval(lower, upper, number_of_cluster, max_unchanged_iterations)
            if len(cluster):

                if total_dist < minimum:
                    best_cluster = cluster
                    minimum = total_dist

            # break

        path = './clusters/euclidean/%d_%d.csv' % (m + 1, number_of_cluster)
        pd.DataFrame(best_cluster).to_csv(path, header=None, index=False)
