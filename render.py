#!/usr/bin/env python

from __future__ import print_function

import sys

import prman


def debug(*args, **kwargs):
    kwargs['file'] = sys.stderr
    print(*args, **kwargs)


class ShaderWrapper(prman.Rif):

    def Surface(self, *args):
        debug('Surface%s' % repr(args))
        self.m_ri.Surface(*args)


ri = prman.Ri()
rif = ShaderWrapper(ri)
prman.RifInit([rif])


ri.Begin(ri.RENDER)
for path in sys.argv[1:]:
    ri.ReadArchive(path)
ri.End()
