%{
#include <iostream>
#include "ada2c.tab.h"
using namespace std;
#define YY_DECL extern "C" int yylex()
int line_num = 1;
%}
%%
[ \t]          ;
begin		   { return BEGINN; }
end            { return END; }
--		   	   { return COMMENT; }
with		   { return WITH; }
procedure	   { return PROCEDURE; }
is 			   { return IS; }
[0-9]+\.[0-9]+ { yylval.fval = atof(yytext); return FLOAT; }
[0-9]+         { yylval.ival = atoi(yytext); return INT; }
[a-zA-Z0-9_]+   {
	yylval.sval = strdup(yytext);
	return STRING;
}
\n             { ++line_num; return ENDL; }
.              ;
%%