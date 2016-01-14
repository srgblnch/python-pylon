# python-pylon
A thin Cython binding of the Basler Pylon SDK.

**'Development Status :: 1 - Planning'**

**'License :: OSI Approved :: 'GNU Lesser General Public License v3 or later (LGPLv3+)'**

It requires to have pylon SDK installed. Check [Basler site](http://www.baslerweb.com/en/support/downloads/software-downloads). The developers are checking the development in pylon major releases
from 2 to 5 over linux systems with architectures of 32 and 64 bits. The 
python versions are 2.7 and 3.4.

Highlight that this is underdevelopment and the master branch is **not** stable.

**Environment load**

To load the environment variables one should execute:

```bash
$ source env.sh pylon X
```

Where 'X' means the pylon SDK major version installed in the system.

##Build

Get the sources from a git repository, like can be:

```bash
$ git clone git@github.com:srgblnch/python-pylon.git
$ cd python-pylon
```

Call the *setup.sh* that will stablish the environment for itself to call the *python setup.py build* for you.

```bash
$ ./setup.sh pylon 5
```

Then a python console should return this:

```python
>>> import pylon
>>> pylon.pylonversionstr()
    '5.0.1-6388'
```

There is no default compilation version and it must be specified in the *setup.sh* and the *env.sh* scripts. For example, with pylon 4:

```bash
$ ./setup.sh pylon 4
```

To have a python answer like:

```python
>>> import pylon
>>> pylon.pylonversionstr()
    '4.0.0-62'
```

Or pylon 3:

```bash
$ ./setup.sh pylon 3
```

With the answer:

```python
>>> import pylon
>>> pylon.pylonversionstr()
    '3.2.1-0'
```

It is still wanted a support for pylon 2:

```bash
$ ./setup.sh pylon 2
```

And the working version say:

```python
>>> import pylon
>>> pylon.pylonversionstr()
    '2.3.3-1337'
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
