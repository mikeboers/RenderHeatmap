#!/usr/bin/env python

from __future__ import print_function

import ctypes as c
import functools
import os
import re
import sys
from subprocess import call, check_output

import prman
from mako.template import Template


def debug(*args, **kwargs):
    kwargs['file'] = sys.stderr
    print(*args, **kwargs)


_memo_store = {}
def memo(func):

    @functools.wraps(func)
    def memoized(*args, **kwargs):
        arg_repr = [repr(x) for x in args]
        arg_repr.extend('%s=%r' % x for x in sorted(kwargs.iteritems()))
        spec = '%s(%s)' % (func.__name__, ', '.join(arg_repr))
        try:
            return _memo_store[spec]
        except KeyError:
            ret = _memo_store[spec] = func(*args, **kwargs)
            return ret

    return memoized


# Consider grabbing the Rix API to get the shader path. But for now, I'm just
# going to hard-code it...
# lib = c.CDLL(os.path.join(os.environ['RMANTREE'], 'lib/libprman.dylib'))
shader_path = ['shaders', os.path.join(os.environ['RMANTREE'], 'lib', 'shaders')]


@memo
def find_shader(name):
    for dir_ in shader_path:
        path = os.path.join(dir_, name) + '.slo'
        if os.path.exists(path):
            return path

@memo
def get_shader_methods(path):
    return tuple(check_output(['sloinfo', '--methods', path]).strip().split())


@memo
def get_shader_parameters(path):
    params = {}
    last = None
    for line in check_output(['sloinfo', path]).splitlines():
        line = line.strip()
        if not line:
            continue

        m = re.match(r'^"(.+?)" "parameter (\S+) (\S+)"$', line)
        if m:
            name, storage, type_ = m.groups()
            last = name
            params[name] = [storage, type_, None]
            continue

        m = re.match(r'^Default value: (.+?)$', line)
        if m:
            default = m.group(1)
            params[last][2] = default

    params = dict((key, tuple(value)) for key, value in params.iteritems())
    return params


@memo
def wrap_shader(name):

    path = find_shader(name)
    if not path:
        debug('wrap_shader: Could not find shader %r.' % (name, ))
        return

    methods = get_shader_methods(path)
    params = get_shader_parameters(path)

    wrapped_name = 'wrapped_%s' % name
    wrapped_path = os.path.join('var', 'shaders', wrapped_name) + '.sl'
    with open(wrapped_path, 'w') as fh:
        template = Template(filename='wrapper.sl.mako')
        fh.write(template.render(name=wrapped_name, params=params, methods=set(methods)))

    call(['shader', '-Ilib', '-o', wrapped_path + 'o', wrapped_path])
    return wrapped_name


class ShaderWrapper(prman.Rif):

    def __init__(self, *args, **kwargs):
        super(ShaderWrapper, self).__init__(*args, **kwargs)
        self._coshader_count = 0

    def Surface(self, name, kw):
        wrapped = wrap_shader(name)
        if wrapped:
            self._coshader_count += 1
            count = self._coshader_count
            handle = '%s_%d' % (wrapped, count)
            self.m_ri.Shader(name, handle, kw)
            self.m_ri.Surface(wrapped, {'string wrapped_handle': handle})


ri = prman.Ri()
rif = ShaderWrapper(ri)
prman.RifInit([rif])


ri.Begin(ri.RENDER)
for path in sys.argv[1:]:
    ri.ReadArchive(path)
ri.End()
