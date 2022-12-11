#!/bin/bash

set -e

ruby hello.rb

if [[ "$MSYSTEM" == "MSYS" ]]; then
    # Make sure ruby does not give away that we are not cygwin
    host_os="$(ruby -e "require 'rbconfig'; puts RbConfig::CONFIG['host_os']")"
    [[ "$host_os" == "cygwin" ]] || (echo "wrong host_os: $host_os"; false)
    ruby_platform="$(ruby -e "puts RUBY_PLATFORM")"
    [[ "$ruby_platform" =~ "cygwin" ]] || (echo "wrong RUBY_PLATFORM: $ruby_platform"; false)
fi
