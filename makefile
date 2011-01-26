NAME=as3-gettext
VERSION_MAJOR=0
VERSION_MINOR=5

VERSION=$(VERSION_MAJOR).$(VERSION_MINOR)

all: swc doc

checkdeps:
	@which mxmlc > /dev/null || { echo "Cant find mxmlc. Check it is in your path"; false; }
	@which amxmlc > /dev/null || { echo "Cant find mxmlc. Check it is in your path"; false; }
	@which acompc > /dev/null || { echo "Cant find compc. Check it is in your path"; false; }
	@which aasdoc > /dev/null || { echo "Cant find asdoc. Check it is in your path"; false; }

swc: checkdeps
	@mkdir -p ./bin
	acompc -sp ./src -is ./src -o ./bin/$(NAME)-$(VERSION).swc

doc: checkdeps
	@mkdir -p ./doc
	aasdoc -sp src -doc-sources src -o doc

clean:
	rm -rf ./bin
	rm -rf ./doc
	rm -f $(NAME)-$(VERSION).tar.gz $(NAME)-$(VERSION).zip

dist: swc doc
	@mkdir -p $(NAME)-$(VERSION)
	@cp -a bin doc $(NAME)-$(VERSION)/
	zip -r $(NAME)-$(VERSION).zip $(NAME)-$(VERSION)
	tar -c $(NAME)-$(VERSION) | gzip > $(NAME)-$(VERSION).tar.gz
	@rm -rf $(NAME)-$(VERSION)

.PHONY: clean all doc swc checkdeps

