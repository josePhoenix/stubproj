#!/usr/bin/env python3
import sys

with open('./circus/circus.ini') as f:
    template = f.read()

output = template.format(PROJ_DIR=sys.argv[1])

with open('./circus/circus.ini', 'w') as f:
    f.write(output)
