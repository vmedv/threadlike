# threadlike lib

> [!NOTE]
> This project is in really early stage, so API will probably change.

## Overview
This library should provide generic API for different threading mechanisms.

For now, we have `std::thread`, `boost::fiber`, `argobots`.

For API overview you can check [main file](src/main.cpp).

To support new mechanism you should implement [`threading` concept](std/threading.h). You can check requirements in comments in
file above.

## TL;DR about c++ concepts

C++ concepts express constraints to the type:
- defined inner types;
- function interface;
- different concepts.

## Usage

You can optionally provide path to argobots installation via `ARGOBOTS_PATH`: if omitted, lib will build without argobots.

> [!NOTE]
> I am currently implementing auto finding argobots in system paths or
> fallbacking to install & build in place.

```bash
cmake -S . -B build -DARGOBOTS_PATH=/path/to/argobots/installation # see argobots guide

cmake --build build
```
