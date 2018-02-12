#!/usr/bin/env bash

set -x
set -e

(cd base && docker build --rm  --pull  -t beanieboi/nginx-php-fpm:5.6 .)
