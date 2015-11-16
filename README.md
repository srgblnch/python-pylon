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

**Important**: The current stage of the development is made using *Pylon 2*. It is not being very tested (by now) with later versions.

```bash
$ ./setup.sh
```

```python
>>> import pylon
>>> pylon.pylonversionstr()
    '2.3.3-1337'
```

By default it is will compile the python module for pylon 4, but this can be modified using arguments in the _setup.sh_ _pylon_ followed by the number:

```bash
$ ./setup.sh pylon 4
```

```python
>>> import pylon
>>> pylon.pylonversionstr()
    '4.0.0-62'
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

##Usage

Once have the *pylon.so* build and placed in the python path, the use can began:

```python
>>> import pylon
>>> factory = pylon.Factory()
>>> factory.nCameras
    3
>>> factory.cameraList
    [2NNNNNN0 (scA1000-30gm), 2NNNNNN1 (acA1300-30gc), 2NNNNNN3 (acA1300-30gc)]
>>> factory.cameraModels
    ['scA1000-30gm', 'acA1300-30gc']
>>> camera = factory.getCameraBySerialNumber(2NNNNNN1)
>>> camera.ipAddress
    'NNN.NNN.NNN.NNN'
>>> camera.isOpen
    False
>>> camera.Open()
>>> camera.isOpen
    True
```
