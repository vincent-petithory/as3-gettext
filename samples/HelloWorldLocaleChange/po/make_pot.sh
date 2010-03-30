#!/bin/sh

find ../src | egrep -i '\.as$|\.mxml$' > files
xgettext --package-name HelloWorldLocaleChange --package-version 0.1 --default-domain HelloWorldLocaleChange --output HelloWorldLocaleChange.pot --from-code=UTF-8 -L C --keyword=_:1 -f files
rm files
