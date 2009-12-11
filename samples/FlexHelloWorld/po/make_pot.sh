#!/bin/sh

find ../src | egrep -i '\.as$|\.mxml$' > files
xgettext --package-name HelloWorld --package-version 0.1 --default-domain HelloWorld --output HelloWorld.pot --from-code=UTF-8 -L C --keyword=_:1 -f files
rm files