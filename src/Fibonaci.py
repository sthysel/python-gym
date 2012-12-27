#! /usr/bin/env python3.3

a,b = 0,1

for n in range(0, 20):
    a,b = b, a + b
    print(a, b)