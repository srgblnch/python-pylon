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
$ ./setup.sh
```

```python
>>> import pylon
>>> pylon.pylonversionstr()
    '4.0.0-62'
```

By default it is will compile the python module for pylon 4, but this can be modified using arguments in the _setup.sh_ _pylon_ followed by the number:

```bash
$ ./setup.sh pylon 2
```

```python
>>> import pylon
>>> pylon.pylonversionstr()
    '2.3.3-1337'
```

```bash
$ ./setup.sh pylon 3
```

```python
>>> import pylon
>>> pylon.pylonversionstr()
    '3.2.1-0'
```

Finally there is a command to clean as an argument of the _setup.sh_.