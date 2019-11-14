#!/bin/env bash

for file in ~/.aliases/**; do
    . $file
done
