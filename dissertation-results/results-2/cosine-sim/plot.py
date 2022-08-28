import matplotlib.pyplot as plt
from scipy.spatial import distance
from scipy import spatial

a = [1, 2]
b = [2, 1]

c = distance.euclidean(a, b)



a = [1, 2, 3]
b = [3, 2, 1]
c = [2, 3, 1]


print(1 - spatial.distance.cosine(a, b))
print(1 - spatial.distance.cosine(a, c))

print(distance.euclidean(a, b))
print(distance.euclidean(a, c))
