import sys

measurements = []
def get_std_dev(ls):
    n = len(ls)
    mean = sum(ls) / n
    var = sum((x - mean)**2 for x in ls) / n
    std_dev = var ** 0.5
    print("ave : "+str(int(mean)))
    print("std : "+str(int(std_dev)))
    return std_dev


with open(sys.argv[1],'r') as f:
    for line in f:
        measurements.append(float(line))
    get_std_dev(measurements)
