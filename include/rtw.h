#pragma once

#include <concepts>
#include <string_view>

template <typename RT>
concept rtw =
    requires(RT t, RT::Workload w, RT::WorkloadArg arg) {
      // "thread-like" unit
      typename RT::thread;
      // mutex type
      typename RT::mutex;
      // create-and-invoke functor yield should be
      // corresponding thread yielding
      typename RT::yield;
      // create-and-invoke functor should return thread-id
      typename RT::id;

      // should be defined Workload type
      requires std::same_as<typename RT::Workload, void (*)(void *)>;

      // args to executed function should be passed via void*
      requires std::same_as<typename RT::WorkloadArg, void *>;

      // string descriptor of threading mechanism,
      // e.g. "std::thread", "boost::fiber"
      { t.mechanismId() } -> std::convertible_to<std::string_view>;

      // producer for threads
      // threads should not be created via constructor of Threading::thread
      // since thread creation may require some global state management
      // (see argobots for example)
      { t.spawn(w, arg) } -> std::same_as<typename RT::thread>;

      // fabric method for creating environment
      // useful for c-like api, where init methods should be called
      // note that env should not be created by hand, only with this method
      { RT::create() };
    };
