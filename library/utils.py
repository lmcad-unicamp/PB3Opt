#!/usr/bin/python3

import numpy as np

#-----------------------------------------------------------------------------------------------------

def get_top_list(size, array):
    top_list = np.zeros(size)
    array_copy = np.copy(array)
    array_copy.sort()
    for i in range(size):
        top_list[i] = np.where(array == array_copy[i])[0][0]
    return top_list
