
compiler: lex.yy.c y.tab.c
	gcc lex.yy.c y.tab.c -o compiler -ly -ll

y.tab.c: compiler.y
	yacc -d compiler.y

lex.yy.c: lexicata.l
	flex lexicata.l
