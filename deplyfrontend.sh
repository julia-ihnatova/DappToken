#!/usr/bin/env bash

rsync -r src/ docs/ #it will take all recursively from src in docs
rsync build/contracts/* docs/


git add .
git commit -m "Compile assets for github pages"
git push -u origin master

