all:
	bison -d parser.y
	flex lexer.l
	gcc lex.yy.c parser.tab.c -o compiler
	g++ optimizer.cpp -o optimizer

run:
	./compiler

opt:
	./optimizer

clean:
	rm -f lex.yy.c parser.tab.c parser.tab.h compiler optimizer
