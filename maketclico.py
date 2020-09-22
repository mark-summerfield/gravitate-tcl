#!/usr/bin/env python3
# TODO replace with makeico.tcl !

import subprocess


SIZES_AND_DEPTHS = (
        (16, 4), (16, 8), (16, 24),
        (32, 4), (32, 8), (32, 24),
        (48, 4), (48, 8), (48, 24),
        (128, 24), (256, 24))

pngs = []
for size, depth in SIZES_AND_DEPTHS:
    target = f'/tmp/icon-{size}-{depth}.png'
    subprocess.run(['inkscape', 'images/icon.svg', '-e', target,
                    f'-w{size}', f'-h{size}', '-z'])
    colors = []
    if depth == 4:
        colors = ['-colors', '16']
    elif depth == 8:
        colors = ['-colors', '256']
    subprocess.run(['convert', '-depth', str(depth)] + colors +
                   [target, target])
    pngs.append(target)
subprocess.run(['convert'] + pngs + ['images/icon.ico'])

