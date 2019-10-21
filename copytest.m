clear
a=spadata

n1=a.addnode(1)
n1.testshallow=1
n1.testdeep=1
n2=a.addnode(2)
a.raw.m0=1;

b=copy(a)

a.nodes(1).testshallow=2
a.nodes(1).testdeep=2
a.raw.m0=2

b.nodes(1).testshallow
b.nodes(1).testdeep
b.raw.m0

a.nodes(1).dependentdeep
b.nodes(1).dependentdeep