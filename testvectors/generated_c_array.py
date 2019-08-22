import sys
ll=[]
for i in range(0,40,2):
    ll.append(sys.argv[1][i:i+2])
print(",0x".join(ll))

