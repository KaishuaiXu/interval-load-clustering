import numpy as np

def next_day(current_day):
    mon = np.array([31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31])

    year = int(current_day[0:4])
    month = int(current_day[5:7])
    day = int(current_day[8:10])

    day = day + 1

    if day > mon[month - 1]:
        day = 1
        month = month + 1

    if month > 12:
        month = 1
        year = year + 1

    m = '%02d' % month
    d = '%02d' % day
    y = str(year)

    return y + '-' + m + '-' + d
