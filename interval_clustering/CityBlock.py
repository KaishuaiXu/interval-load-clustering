import numpy as np

def dist(a, b, alpha, beta, lamb):

    tmp = (abs(a - alpha) + abs(b - beta)) * lamb
    tmp = tmp.sum(axis=1)

    return tmp

def update_centroids(x, y, assignment):
    tmp_x = x[assignment[0]]
    for i in range(1, len(assignment)):
        tmp_x = np.vstack((tmp_x, x[assignment[i]]))
    tmp_x = np.median(tmp_x, 0)

    tmp_y = y[assignment[0]]
    for i in range(1, len(assignment)):
        tmp_y = np.vstack((tmp_y, y[assignment[i]]))
    tmp_y = np.median(tmp_y, 0)

    return tmp_x, tmp_y

def update_lambda(a, b, alpha, beta, cluster, dim):

    tmp_k = np.zeros([dim])
    number_of_cluster = alpha.shape[0]
    for k in range(number_of_cluster):
        assignment = np.squeeze(np.where(cluster == k))

        tmp_a = a[assignment[0]]
        for i in range(1, len(assignment)):
            tmp_a = np.vstack((tmp_a, a[assignment[i]]))

        tmp_b = b[assignment[0]]
        for i in range(1, len(assignment)):
            tmp_b = np.vstack((tmp_b, b[assignment[i]]))

        tmp_k = (abs(tmp_a - alpha[k]) + abs(tmp_b - beta[k])).sum(axis=0) + tmp_k

    tmp_k = np.squeeze(tmp_k)
    tmp_p = 1
    for h in range(dim):
        tmp_p = tmp_p * tmp_k[h]
    tmp_p = np.power(tmp_p, 1/dim)

    tmp = tmp_p / tmp_k

    return np.array(tmp)
