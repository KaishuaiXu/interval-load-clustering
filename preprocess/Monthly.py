# -*- coding: utf-8 -*-

import pandas as pd

month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
path = '../data/meters.csv'
meters = pd.read_csv(path)
for i in range(len(meters)):
    if i % 100 == 0:
        print(i)

    path = '../data/load_data/%d.csv' % meters['meter_id'][i]
    data = pd.read_csv(path)
    for m in range(12):
        start = '2010-%02d-01' % (m + 1)
        end = '2010-%02d-%d' % (m + 1, month[m])
        d = data.query(" date >= '%s' & date <= '%s' " % (start, end))
        lower = d['lower'].values
        upper = d['upper'].values

        tmp_l = lower[0:24]
        tmp_u = upper[0:24]
        for j in range(1, int(len(d) / 24)):
            tmp_l = tmp_l + lower[j * 24:(j + 1) * 24]
            tmp_u = tmp_u + upper[j * 24:(j + 1) * 24]
        tmp_l = tmp_l / int(len(d) / 24)
        tmp_u = tmp_u / int(len(d) / 24)
        path = '../data/load_data_monthly/%d_%d_lower.csv' % (meters['meter_id'][i], m + 1)
        pd.DataFrame(tmp_l).to_csv(path, index=False, header=None)
        path = '../data/load_data_monthly/%d_%d_upper.csv' % (meters['meter_id'][i], m + 1)
        pd.DataFrame(tmp_u).to_csv(path, index=False, header=None)
        # break
    # break
