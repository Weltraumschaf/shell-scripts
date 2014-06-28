#!/bin/bash

sudo chmod -vR a+rX /usr/local/Cellar
sudo chmod -vh a+rX /usr/local/Cellar
sudo chmod -vh a+rx /usr/local/bin/*
sudo chmod -vh a+rx /usr/local/Cellar/maven/3.2.2/bin/*

echo "Finished :)"