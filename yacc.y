%{
    #include <stdio.h>
    int iflabel = 0;
    int yylex(void);
    void yyerror(const char *s);
    int yyparse(void);
    int yylex();
%}


%token ID
%token NUMBER
%left LP
%right RP
%left LCB
%right RCB


%left ADD
%left SUB
%left DIV
%left MUL
%token GT
%token LT
%token GE
%token LE
%token EQ
%token UE

%token IF
%token WHILE
%right ASSIGN
%right SC

%%
statementlist    :   statementlist statement | statement;
block            :   LCB statementlist RCB;
conditionE       :   E RELOP E {printf("\tGT?\n", $2);};
RELOP            :   GT|LT|GE|LE|EQ|UE;
ifstatement      :   IF LP conditionE {printf("\tjnz L%d\n", iflabel);} RP statement {printf("L%d\n", iflabel++);};

assignstatement  :   ID ASSIGN E SC {printf("\tPOP %c\n", $1);};
statement        :   assignstatement | ifstatement | block; 

E           :   E ADD E {printf("\tADD\n");}|
                E SUB E|
                E MUL E|
                E DIV E|
                NUMBER {printf("\tpush %d\n", $1);}|
                ID {printf("\tpush %c\n", $1);};
