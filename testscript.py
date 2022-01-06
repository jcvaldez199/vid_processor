testarr = [{"loc":[0,0],"grayscale":0,"frame":0},{"loc":[1,1],"grayscale":1,"frame":1}]

newone = [ {"loc":x["loc"],"grayscale":x["grayscale"], "frame":2}  for x in testarr]
print(newone)

for x in range(1,10):
    print(x)


