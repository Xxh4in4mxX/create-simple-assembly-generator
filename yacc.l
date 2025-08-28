%{
    #include "yacc.tab.h"
    extern int yylval;
    int yyparse(void);
%}


%%

[0-9]+                      {yylval = atoi(yytext);return NUMBER;}
"int"                       {printf("keyword int\n");}
"double"                    {printf("keyword double\n");}
"void"                      {printf("keyword void\n");}
"for"                       {printf("keyword for\n");}
"if"                        {return IF;}
"while"                     {return WHILE;}

[A-z_][A-z0-9_]*            {yylval = yytext[0]; return ID;}
"+"                         {return ADD;}
"-"                         {return SUB;}
"/"                         {return DIV;}
"*"                         {return MUL;}
"="                         {return ASSIGN;}

">"                         {return GT;}
"<"                         {return LT;}
">="                        {return GE;}
"<="                        {return LE;}
"=="                        {return EQ;}
"!="                        {return UE;}

";"                         {return SC;}
"("                         {return LP;}
")"                         {return RP;}
"{"                         {return LCB;}
"}"                         {return RCB;}

%%
int yywrap() {return -1;}
int main() { yyparse(); }
int yyerror() {printf("parse error\n");}
