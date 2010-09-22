#!/bin/sh

find ../src | egrep -i '\.as$|\.mxml$' > files
xgettext --package-name prioritylist --package-version 0.1 --default-domain prioritylist --output prioritylist.pot --from-code=UTF-8 -L C --keyword=_:1 -f files
rm files
