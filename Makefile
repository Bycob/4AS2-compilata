
compiler: lex.yy.c y.tab.c
	gcc lex.yy.c y.tab.c lt_symbols.c -o compiler -ly -ll

y.tab.c: compiler.y
	yacc -d compiler.y

lex.yy.c: lexicata.l
	flex lexicata.l

test: compiler
	./compiler < test.c

testd: compiler
	./compiler -d < test.c
