import pandas as pd
import numpy as np

month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
meters = pd.read_csv('../data/meters.csv')
dist = 'hausdorff'

for m in range(12):
    print(m)
    for number_of_cluster in range(2, 11):

        lower = np.zeros((number_of_cluster, month[m] * 24))
        upper = np.zeros((number_of_cluster, month[m] * 24))

        path = '../clusters/' + dist + '/%d_%d.csv' % (m + 1, number_of_cluster)
        cate = np.squeeze(pd.read_csv(path, header=None).values)

        for i in range(len(meters)):

            path = '../data/load_data/%d.csv' % (meters['meter_id'][i])
            data = pd.read_csv(path)

            start = '2010-%02d-01' % (m + 1)
            end = '2010-%02d-%d' % (m + 1, month[m])
            d = data.query(" date >= '%s' & date <= '%s' " % (start, end))
            tmp_lower = d['lower'].values
            tmp_upper = d['upper'].values

            lower[cate[i]] = lower[cate[i]] + tmp_lower
            upper[cate[i]] = upper[cate[i]] + tmp_upper

        path = '../data/load_data_clustered/' + dist + '/%d_%d_lower.csv' % (m + 1, number_of_cluster)
        pd.DataFrame(lower).to_csv(path, index=False, header=None)
        path = '../data/load_data_clustered/' + dist + '/%d_%d_upper.csv' % (m + 1, number_of_cluster)
        pd.DataFrame(upper).to_csv(path, index=False, header=None)
