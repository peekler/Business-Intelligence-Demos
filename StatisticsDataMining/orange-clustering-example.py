import Orange
from matplotlib import pyplot as plt

# adat betoltes
data = Orange.data.Table("C:\\Users\\Administrator\\Documents\\GY-traffic-aggregate-csv.csv")

# klaszterezes
km = Orange.clustering.kmeans.Clustering(data, 2)

# vizualizacio
x = [d["Voice"] for d in data]
y = [d["Text"] for d in data]
colors = ["c", "w"]
cs = "".join([colors[c] for c in km.clusters])
plt.scatter(x, y, c=cs, s=10)
