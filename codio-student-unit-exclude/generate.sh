#!/usr/bin/env bash

cd "$(dirname "$0")"

cd book-converter

python3 converter.py ../book-structure -y

cd ..

rm -rf .guides
rm -rf rmarkdown-formats_files
rm -rf communicate-plots_files
rm -rf model-many_files
rm -rf model-building_files
rm -rf model-basics_files
rm -rf pipes_files
rm -rf datetimes_files
rm -rf factors_files
rm -rf tidy_files
rm -rf EDA_files
rm -rf transform_files
rm -rf visualize_files
rm -rf diagrams
rm -rf images

cp -r book-structure/generate/* ../.
cp -r book-structure/generate/.guides ../.
