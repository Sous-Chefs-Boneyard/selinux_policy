#!/usr/bin/python

# Cookbook: selinux_policy

# Locates a port policy in SELinux
# Exits with 0 if range supplied (could be a single port) was located, either
# belonging to a specific label if such was provided, or at all if one wasn't

# Args:
# port_locate.py <protocol> <port>|(<port_start>-<port_end>) [<existing label>]
# Exit codes:
# 0: Complete match
# 1: No such SELinux rule
# 2: SELinux rule exists, label mismatch

# http://2ndscale.com/rtomayko/2004/cleanest-python-find-in-list-function
def find(f, seq):
  """Return first item in sequence where f(item) == True."""
  for item in seq:
    if f(item): 
      return item

import sys
protocol = sys.argv[1]
port_or_range = sys.argv[2]
if '-' in port_or_range:
    port_start,port_end = map(int, port_or_range.split('-'))
else:
    port_start = port_end = int(port_or_range)
if len(sys.argv) > 3:
    label = sys.argv[3]
else:
    label = None

import seobject
pr=seobject.portRecords().get_all()
matching_key = find(lambda k: port_start<=k[0] and port_end>=k[1] and k[2]==protocol ,pr.keys())
if matching_key:
    actual_label = pr[matching_key][0]
    if (not label) or (label == actual_label):
        print 'Found key',matching_key
        sys.exit(0)
    else:
        print 'Label mismatch',matching_key,actual_label
        sys.exit(2)
else:
    print 'No matching key found'
    sys.exit(1)
