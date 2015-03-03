#!/bin/bash

rm -f rose_test1.cpp

cp ../src/identityTranslator .
./identityTranslator test1.cpp

if diff rose_test1.cpp test1_oracle.cpp ; then
	echo -e "The example project was successfully tested! The identity translator is running correctly!"
else
	echo -e "The example project is failing! Something has gone wrong ... "
fi

