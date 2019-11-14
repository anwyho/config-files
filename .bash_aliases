#!/bin/bash

for file in ~/.aliases/**; do
    source $file
done
