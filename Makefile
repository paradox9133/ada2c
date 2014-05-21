ada2c.tab.c ada2c.tab.h: ada2c.y
	bison -d ada2c.y

lex.yy.c: ada2c.l ada2c.tab.h
	flex ada2c.l

ada2c: lex.yy.c ada2c.tab.c ada2c.tab.h
	g++ ada2c.tab.c lex.yy.c -lfl -o ada2c