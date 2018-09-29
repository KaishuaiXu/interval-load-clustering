import mysql.connector as mc
import pandas as pd
from Preprocess.NextDay import next_day

con = mc.connect(host='***', user='root', password='***', database='Irish_smart_meter')
cursor = con.cursor()

meters = pd.read_csv('meters.csv')
l = len(meters)
for i in range(l):
    sql = "select * from load_series_1 where meter_id=%d" % (meters['meter_id'][i])
    cursor.execute(sql)
    data = pd.DataFrame(cursor.fetchall())

    # 原序列区间化
    upper = []
    lower = []
    for j in range(int(len(data)/2)):
        if data[3][j * 2] > data[3][j * 2 + 1]:
            upper.append(data[3][j * 2])
            lower.append(data[3][j * 2 + 1])
        else:
            upper.append(data[3][j * 2 + 1])
            lower.append(data[3][j * 2])
    upper = pd.DataFrame(upper)
    lower = pd.DataFrame(lower)

    # 时间粒度调整
    half_hour = list(range(24)) * 536
    half_hour = pd.DataFrame(half_hour)
    half_hour[0] = half_hour[0] + 1

    # 日期调整
    date = []
    tmp = '2009-07-14'
    for _ in range(536):
        date.extend([tmp] * 24)
        tmp = next_day(tmp)
    date = pd.DataFrame(date)

    total = pd.concat([date, half_hour, lower, upper], axis=1)
    total.columns = ['date', 'time', 'lower', 'upper']
    path = '***/load_data/%d.csv' % meters['meter_id'][i]
    total.to_csv(path, index=False)
