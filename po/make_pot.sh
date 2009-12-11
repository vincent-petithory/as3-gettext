#!/bin/sh

find ../src | egrep -i '\.as$|\.mxml$' > files
xgettext --package-name libas3gnugettext --package-version 0.1 --default-domain libas3gnugettext --output libas3gnugettext.pot --from-code=UTF-8 -L C --keyword=_:1 -f files
rm files