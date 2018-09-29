# -*- coding: utf-8 -*-

import pandas as pd
import numpy as np

meters = pd.read_csv('../meters.csv')

for m in range(12):
    lower = []
    upper = []
    print(m + 1)
    for i in range(len(meters)):

        path_l = '../load_data_monthly/%d_%d_lower.csv' % (meters['meter_id'][i], m + 1)
        path_u = '../load_data_monthly/%d_%d_upper.csv' % (meters['meter_id'][i], m + 1)
        tmp_l = pd.read_csv(path_l, header=None)
        tmp_u = pd.read_csv(path_u, header=None)

        tmp_l = np.squeeze(tmp_l.values)
        tmp_u = np.squeeze(tmp_u.values)

        lower.append(tmp_l)
        upper.append(tmp_u)
        # break
    lower = np.array(lower)
    upper = np.array(upper)

    maximum = np.maximum(np.max(lower), np.max(upper))
    minimum = np.maximum(np.min(lower), np.min(upper))

    lower = (lower - minimum) / (maximum - minimum)
    upper = (upper - minimum) / (maximum - minimum)

    pd.DataFrame(lower).to_csv('../load_data_normalized/%d_lower.csv' % (m + 1),
                               index=False, header=None)
    pd.DataFrame(upper).to_csv('../load_data_normalized/%d_upper.csv' % (m + 1),
                               index=False, header=None)

    # break
