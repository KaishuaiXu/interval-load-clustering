from sklearn.cluster.k_means_ import _k_init
from sklearn.utils.extmath import row_norms
from sklearn.utils import check_random_state
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
        for times in range(100):
            print('Times: %d' % (times+1))
            tmp = (lower + upper) / 2
            x_squared_norms = row_norms(tmp, squared=True)
            random_state = check_random_state(None)
            centers = _k_init(tmp, number_of_cluster, x_squared_norms, random_state)
            print(centers)
            break
            # cluster = k_means_interval(lower, upper, number_of_cluster, max_unchanged_iterations)
            # if len(cluster):
            #     path = './clusters/euclidean/%d_%d.csv' % (m + 1, number_of_cluster)
            #     pd.DataFrame(cluster).to_csv(path, header=None, index=False)
