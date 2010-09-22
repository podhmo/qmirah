qmirah
======
this is compile daemon server for quick compiling in mirah

dependency
------

qmirah is too ad-hoc!!
it depends below.

* netcat (nc command)
* ruby (erb, yaml, rake)
* jruby, mirah

install
------
install <a href="http://www.mirah.org/">mirah</a>, after that
clone this repository.

    $ vi setting.yaml # edit file
    $ rake install


how to use
---------

    $ ./qmirah examples/fib.mirah       # run script
    $ ./qmirahc examples/fib.mirah      # generate classfile
    $ ./qmirahc -j  examples/fib.mirah  # generate java source 


toy-benchmarking
----------------
    $ time mirah examples/hello.mirah                  
    hello
    mirah examples/hello.mirah  4.54s user 0.17s system 132% cpu 3.553 total

    $ time ./qmirah examples/hello.mirah               
    ./qmirah examples/hello.mirah  0.01s user 0.02s system 100% cpu 0.030 total
    $ recv: run -d /home/nao/sandbox/qmirah examples/hello.mirahx/qmirah]
    hello
