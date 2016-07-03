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

You can run all tests using next command (it must be run from **drude/tests directory**):
```
./run-tests.sh
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