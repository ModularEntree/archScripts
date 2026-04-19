clean: 
	for FILE in `ls | grep -v .sh | grep -v .md | grep -v Makefile`; do rm $FILE; done

*: *.sh
	cp -f $@ $*

.PHONY: *
