
compiler: lex.yy.c y.tab.c lt_symbols.c lt_instruction_asm.c
	gcc lex.yy.c y.tab.c lt_symbols.c lt_instruction_asm.c lt_jmpc.c -g -Og -o compiler -ly -ll

y.tab.c: compiler.y
	yacc -d compiler.y

lex.yy.c: lexicata.l
	flex lexicata.l

test: compiler
	./compiler < test.c

testd: compiler
	./compiler -d < test.c

# Unit tests
unittest: test_symbols
	./test_symbols

test_symbols: libtest.o tests/test_symbols.c lt_symbols.c
	gcc -I"." lt_symbols.c libtest.o tests/test_symbols.c -g -Og -o test_symbols

libtest.o: tests/libtest.c
	gcc -c tests/libtest.c

clean:
	rm lex.yy.c y.tab.c y.tab.h compiler
