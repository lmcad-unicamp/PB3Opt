import numpy as np
import matplotlib.pyplot as plt

v = [1,2]
w = [-1,2]
z = [1.5,1.5]

array = np.array([[0, 0, v[0], v[1]], 
                     [0, 0, w[0], w[1]]])

X, Y, V, W = zip(*array)
plt.figure()
plt.ylabel('y')
plt.xlabel('x')
ax = plt.gca()

ax.annotate(f'a({v[0]},{v[1]})', (v[0],v[1]),fontsize=14)
plt.scatter(v[0],v[1], s=10,c='black')

ax.annotate(f'b({w[0]},{w[1]})', (w[0],w[1]),fontsize=14)
plt.scatter(w[0], w[1], s=10,c='black')
ax.quiver(X, Y, V, W, angles='xy', scale_units='xy',color=['r','black'],scale=1)

plt.scatter(0, 0, s=10,c='black')

plt.grid()
plt.draw()
ax.set_axisbelow(True)

plt.savefig("ranking-exemplo.pdf")

plt.show()
