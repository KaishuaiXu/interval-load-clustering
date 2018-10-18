# -*- coding: utf-8 -*-

import pandas as pd
import numpy as np

meters = pd.read_csv('../data/meters.csv')

for m in range(12):
    lower = []
    upper = []
    print(m + 1)
    for i in range(len(meters)):

        path_l = '../data/load_data_monthly/%d_%d_lower.csv' % (meters['meter_id'][i], m + 1)
        path_u = '../data/load_data_monthly/%d_%d_upper.csv' % (meters['meter_id'][i], m + 1)
        tmp_l = pd.read_csv(path_l, header=None)
        tmp_u = pd.read_csv(path_u, header=None)

        tmp_l = np.squeeze(tmp_l.values)
        tmp_u = np.squeeze(tmp_u.values)

        lower.append(tmp_l)
        upper.append(tmp_u)
        # break
    lower = np.array(lower)
    upper = np.array(upper)

    pd.DataFrame(lower).to_csv('../data/load_data_profiles/%d_lower.csv' % (m + 1),
                               index=False, header=None)
    pd.DataFrame(upper).to_csv('../data/load_data_profiles/%d_upper.csv' % (m + 1),
                               index=False, header=None)
    # break
