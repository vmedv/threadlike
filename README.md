# rtw (runtime wrapper) lib

> [!NOTE]
> This project is in really early stage, so API will probably change.

## Overview

This library should provide generic API for different threading mechanisms.

You want to use `rtw` interface library in other projects, basically.

For now, we have `std::thread`, `boost::fiber`, `argobots`.

For API overview you can check [main file](src/main.cpp).

To support new mechanism you should implement [`rtw` concept](include/rtw.h). 
You can check requirements in comments in file above.

## TL;DR about c++ concepts

C++ concepts express constraints to the type:
- defined inner types;
- function interface;
- different concepts.

## Usage

You can enable useful modules (everything disabled by default): e.g. `-DUSE_FIBERS=on`.
Also be prepared that lib will build argobots from scratch.
(if you need some local tweaks, see [config script](./scripts/abt-install.sh))

> [!NOTE]
> You can't actually disable std::threads wrapper, but there are generally no reason to do this.

Example of usage:

```bash
cmake -S . -B <build-dir> [-DUSE_{MODULE}=on]* 

cmake --build build
```
