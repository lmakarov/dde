# Bats tests for dsh

You need to install [Bats](https://github.com/sstephenson/bats) before running tests.
You need to have [Drupal 7 sample project](https://github.com/blinkreaction/drude-d7-testing) installed in your projects directory.
You must have next structure of projects directory:
>     projects
>       ...
>       \_ drude
>       \_ drude-d7-testing
>       ...

You can run any test from **drude-d7-testing** directory using next command:
```
bats ../drude/tests/start.bats
```

By default OS is "OS X" (mac). You can set enviroment for test (OS is mac|linux|win):
```
OS=linux bats ../drude/tests/start.bats
```

You can run all tests using next command (it must be run from **drude/tests directory**):
```
./run-tests.sh
```

Or you can set OS:
```
OS=linux ./run-tests.sh
```
or specify parameter:

```
./run-tests.sh linux
```


## Tests overview

In most cases test name is same as commands name:
```
init.bats => dsh init
start.bats => dsh start
...
```

There are also files with tests for dsh functions:
```
helper_functions.bats - Helper functions
(@todo add others)
```