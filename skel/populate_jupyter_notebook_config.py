#!/usr/bin/env python3
import sys
from notebook.auth import passwd
import random

with open('./jupyter_notebook_config.py') as f:
    template = f.read()

output = template.format(
    cookie_secret=random.getrandbits(256),
    password=passwd(),
    port=sys.argv[1]
)

with open('./jupyter_notebook_config.py', 'w') as f:
    f.write(output)
