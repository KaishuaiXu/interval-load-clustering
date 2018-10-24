import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
meters = pd.read_csv('./data/meters.csv')
dist = 'cityblock'

m = 2
number_of_cluster = 5
plt.figure(figsize=(8, 5))

ave_upper = np.zeros(24)
ave_lower = np.zeros(24)
n = 0

path = './clusters/' + dist + '/%d_%d.csv' % (m + 1, number_of_cluster)
cate = np.squeeze(pd.read_csv(path, header=None).values)

for i in range(len(meters)):

    path = './data/load_data_monthly/%d_%d_upper.csv' % (meters['meter_id'][i], m + 1)
    upper = pd.read_csv(path, header=None)
    upper = np.squeeze(upper.values)

    path = './data/load_data_monthly/%d_%d_lower.csv' % (meters['meter_id'][i], m + 1)
    lower = pd.read_csv(path, header=None)
    lower = np.squeeze(lower.values)

    if cate[i] == 0:

        n = n + 1

        plt.plot(list(range(1, 25)), lower, alpha=0.8, color='skyblue', linewidth=0.5)
        plt.plot(list(range(1, 25)), upper, alpha=0.8, color='lightcoral', linewidth=0.5)
        plt.xlabel('time (h)')
        plt.ylabel('upper load values (kW·h)')
        new_ticks = np.linspace(1, 24, 24)
        plt.xticks(new_ticks)
        plt.xlim((1, 24))
        plt.fill_between(list(range(1, 25)), lower, upper, color='grey', alpha=0.1)
        # break

plt.savefig('demo.pdf')
plt.show()
