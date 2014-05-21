%{
#include <cstdio>
#include <iostream>
using namespace std;

#include "ada2c.tab.h"  // to get the token types that we return

// stuff from flex that bison needs to know about:
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
extern int line_num;
 
void yyerror(const char *s);
%}

// Bison fundamentally works by asking flex to get the next token, which it
// returns as an object of type "yystype".  But tokens could be of any
// arbitrary data type!  So we deal with that in Bison by defining a C union
// holding each of the types of tokens that Flex could return, and have Bison
// use that union instead of "int" for the definition of "yystype":
%union {
	int ival;
	float fval;
	char *sval;
}

// define the constant-string tokens:
%token ADA TYPE
%token END ENDL
%token BEGINN
%token COMMENT 
%token WITH 
%token IS
%token PROCEDURE

// define the "terminal symbol" token types I'm going to use (in CAPS
// by convention), and associate each with a field of the union:
%token <ival> INT
%token <fval> FLOAT
%token <sval> STRING

%%
ada:
	comment header procedure  { cout << "done with a ada2c file!" << endl; }
	;
comment:
	COMMENT { cout << "//"; } sentence ENDL { cout << endl; }
	;
sentence:
	sentence STRING { cout  << $2 << " "; }
	| STRING { cout  << $1 << " "; }
	;
header:
	WITH STRING ENDLS { cout << "include <" << $2 << ">" << endl; }
	;
procedure:
	PROCEDURE STRING IS ENDL { cout << "void " << $2  << "()" << endl; } BEGINN ENDL { cout << "{" << endl; } sentence ENDL END { cout << "}" << endl; } STRING
	;
ENDLS:
	ENDLS ENDL
	| ENDL ;
%%

main() {
	// open a file handle to a particular file:
	FILE *myfile = fopen("in.adb", "r");
	// make sure it's valid:
	if (!myfile) {
		cout << "I can't open in.adb!" << endl;
		return -1;
	}
	// set lex to read from it instead of defaulting to STDIN:
	yyin = myfile;

	// parse through the input until there is no more:
	
	do {
		yyparse();
	} while (!feof(yyin));
	
}

void yyerror(const char *s) {
	cout << "EEK, parse error on line " << line_num << "!  Message: " << s << endl;
	// might as well halt now:
	exit(-1);
}