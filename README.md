# python-pylon
A thin Cython binding of the Basler Pylon SDK.

It requires to have pylon SDK installed. Check [Basler site](http://www.baslerweb.com/en/support/downloads/software-downloads).

##Build

```bash
$ git clone git@github.com:srgblnch/python-pylon.git
$ cd python-pylon
```

This variable $PYLON_BASE is the key to link this module with an specific release of pylon.

It's time for the required includes before build, specify to use g++ and pylon shared libraries.

```bash
$ export PYLON_BASE=/opt/pylon
$ export CFLAGS="-I$PYLON_BASE/include -I$PYLON_BASE/genicam/library/CPP/include "
$ python setup.py build
```

Using different $PYLON_BASE for pylon major releases 2, 3 or 4 they can be saw in code that the used SDK for the python module is the wanted one:

```python
>>> import pylon
>>> pylon.pylonversionstr()
 '2.3.3-1337'

>>> import pylon
>>> pylon.pylonversionstr()
'3.2.1-0'

>>> import pylon
>>> pylon.pylonversionstr()
 '4.0.0-62'
```