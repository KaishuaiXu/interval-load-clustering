import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
meters = pd.read_csv('./data/meters.csv')
dist = 'cityblock'

m = 1
number_of_cluster = 5
for series in range(number_of_cluster):
    plt.figure(figsize=(14, 5))

    ave_upper = np.zeros(24)
    ave_lower = np.zeros(24)
    n = 0
    max_tmp = 0

    path = './clusters/' + dist + '/%d_%d.csv' % (m + 1, number_of_cluster)
    cate = np.squeeze(pd.read_csv(path, header=None).values)

    for i in range(len(meters)):

        path = './data/load_data_monthly/%d_%d_upper.csv' % (meters['meter_id'][i], m + 1)
        upper = pd.read_csv(path, header=None)
        upper = np.squeeze(upper.values)

        path = './data/load_data_monthly/%d_%d_lower.csv' % (meters['meter_id'][i], m + 1)
        lower = pd.read_csv(path, header=None)
        lower = np.squeeze(lower.values)

        if cate[i] == series:

            # if np.max(upper) > max_tmp:
            #     max_tmp = np.max(upper)
            n = n + 1
            plt.subplot(1, 2, 1)
            ave_lower = lower + ave_lower
            plt.plot(list(range(1, 25)), lower, alpha=0.5, color='grey', linewidth=0.5)
            plt.xlabel('time (h)')
            plt.ylabel('lower load values (kW·h)')
            new_ticks = np.linspace(1, 24, 24)
            plt.xticks(new_ticks)
            plt.xlim((1, 24))

            ave_upper = upper + ave_upper
            plt.subplot(1, 2, 2)
            plt.plot(list(range(1, 25)), upper, alpha=0.5, color='grey', linewidth=0.5)
            plt.xlabel('time (h)')
            plt.ylabel('upper load values (kW·h)')
            new_ticks = np.linspace(1, 24, 24)
            plt.xticks(new_ticks)
            plt.xlim((1, 24))

    plt.subplot(1, 2, 1)
    plt.plot(list(range(1, 25)), ave_lower / n, color='black', linewidth=1)
    plt.ylim((0, 2))
    # plt.ylim((0, max_tmp * 0.75))
    plt.subplot(1, 2, 2)
    plt.plot(list(range(1, 25)), ave_upper / n, color='black', linewidth=1)
    plt.ylim((0, 2))
    # plt.ylim((0, max_tmp * 0.75))

    path = 'cluster_fig_%d_%d_%d.pdf' % (m, number_of_cluster, series)
    plt.savefig(path)
    plt.show()
