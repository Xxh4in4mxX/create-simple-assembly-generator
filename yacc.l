%{
    #include "yacc.tab.h"
    // extern int yylval;
    int yyparse(void);
%}


%%

[ \n\t\r]+                    {}
[0-9]+                      {yylval.ival = atoi(yytext);return NUMBER;}
[0-9]+\.[0-9]+([eE][-+]?[0-9]+)? {yylval.fval = atof(yytext);return FLOAT;}
"int"                       {printf("keyword int\n");}
"double"                    {printf("keyword double\n");}
"void"                      {printf("keyword void\n");}
"for"                       {return FOR;}
"if"                        {return IF;}
"else"                      {return ELSE;}
"while"                     {return WHILE;}
"do"                        {return DO;}
"break"                     {return BREAK;}
"continue"                  {return CONTINUE;}
"switch"                    {return SWITCH;}
"case"                      {return CASE;}

[A-Za-z_][0-9A-Za-z_]*            {yylval.sval = strdup(yytext); return ID;}

"+"                         {return ADD;}
"-"                         {return SUB;}
"/"                         {return DIV;}
"*"                         {return MUL;}
"="                         {return ASSIGN;}

">"     { yylval.sval = strdup("GT?"); return GT; }
"<"     { yylval.sval = strdup("LT?"); return LT; }
">="    { yylval.sval = strdup("GE?"); return GE; }
"<="    { yylval.sval = strdup("LE?"); return LE; }
"=="    { yylval.sval = strdup("EQ?"); return EQ; }
"!="    { yylval.sval = strdup("UE?"); return UE; }

";"                         {return SC;}
":"                         {return COLON;}
","                         {return CM;}
"("                         {return LP;}
")"                         {return RP;}
"{"                         {return LCB;}
"}"                         {return RCB;}

.                           {printf("Unknown char: %s\n", yytext);}

%%
int yywrap() {return -1;}
int main() { yyparse(); }
int yyerror() {printf("parse error\n");}
int lineno = 1;
