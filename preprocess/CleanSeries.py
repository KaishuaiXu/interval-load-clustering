import numpy as np
import pandas as pd
import mysql.connector as mc

con = mc.connect(user='root', password='***', database='Irish_smart_meter')
cursor = con.cursor()
cursor.execute("SELECT meter_id FROM type WHERE type=1;")
type = np.squeeze(cursor.fetchall())

refined_series = []
for i in range(len(type)):
    cursor.execute("SELECT load_data FROM load_series_1 WHERE meter_id=%d" % type[i])
    load_series = np.squeeze(cursor.fetchall())
    t = 0
    for l in load_series:
        if l == 0:
            t = t + 1
    if t < 10:
        refined_series.append(type[i])
        print(type[i])
    # break

meters = pd.DataFrame(refined_series)
meters.columns = ['meter_id']
meters.to_csv('../data/meters.csv', index=False)

