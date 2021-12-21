import numpy as np
import matplotlib.pyplot as plt
# consider two vectors A and B in 2-D
#A=np.array([1,2])
#B=np.array([2,1])
#ax = plt.axes()
#ax.arrow(0.0, 0.0, A[0], A[1], head_width=0.4, head_length=0.5)
#plt.annotate(f"A({A[0]},{A[1]})", xy=(A[0], A[1]),xytext=(A[0]+0.5, A[1]))
#ax.arrow(0.0, 0.0, B[0], B[1], head_width=0.4, head_length=0.5)
#plt.annotate(f"B({B[0]},{B[1]})", xy=(B[0], B[1]),xytext=(B[0]+0.5, B[1]))
#plt.xlim(0,10)
#plt.ylim(0,10)
#plt.show()
#plt.close()
## cosine similarity between A and B
#cos_sim=np.dot(A,B)/(np.linalg.norm(A)*np.linalg.norm(B))

A=np.array([1,2])
B=np.array([0,0])
C=np.array([2,1.5])
D=np.array([2,2])
E=np.array([-1,2])

cos_sim=np.dot(A,B)/(np.linalg.norm(A)*np.linalg.norm(B))
print (f"Cosine Similarity between A and B:{cos_sim}")
cos_sim=np.dot(A,C)/(np.linalg.norm(A)*np.linalg.norm(C))
print (f"Cosine Similarity between A and C:{cos_sim}")
cos_sim=np.dot(A,D)/(np.linalg.norm(A)*np.linalg.norm(D))
print (f"Cosine Similarity between A and D:{cos_sim}")
cos_sim=np.dot(A,E)/(np.linalg.norm(A)*np.linalg.norm(E))
print (f"Cosine Similarity between A and E:{cos_sim}")

print(np.linalg.norm(A-B))
print(np.linalg.norm(A-C))
print(np.linalg.norm(A-D))
