#!/bin/bash

# kill all running X.org processes
for i in $1
do
	kill $i
done
