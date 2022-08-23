#!/bin/bash

set -e -o xtrace

mkdir input-flattened output-flattened
find /input -type f | parallel -j 1 --colsep / -- cp /input/{3}/{4} input-flattened/{3}-{4}
python user_scripts/parse_folder.py -i input-flattened --output-xml-path output-flattened -c config.ini
parallel -j 1 --colsep '[/-]' -- 'mkdir -p /output/{3}; cp output-flattened/{3}-{4} /output/{3}/{4}' ::: output-flattened/*.xml
LC_ALL=C parallel -- 'python ../page-to-text/page_to_text.py {} > {.}.txt' ::: output-flattened/*.xml
parallel -j 1 --colsep '[/-]' -- 'cp output-flattened/{3}-{4} /output/{3}/{4}' ::: output-flattened/*.txt
