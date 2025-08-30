%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "stack.h"
#define MAX_STACK 100
void yyerror(const char *s);
int yyparse(void);
int yylex();
int yylex(void);
int labelCount = 0;
char* labelStack[MAX_STACK];
int top = -1;
char* newLabel() {
    char *buf = malloc(10);
    sprintf(buf, "L%1d", labelCount++);
    return buf;
}
void pushLabel(char *label) {
    if (top >= MAX_STACK - 1) {
        printf("Stack overflow\n");
        exit(1);
    }
    labelStack[++top] = label;
}
char* popLabel() {
    if (top < 0) {
        printf("Stack underflow\n");
        exit(1);
    }
    return labelStack[top--];
}

int indentLevel = 0;
void emit(const char *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    int isLabel = 0;
    size_t len = strlen(fmt);
    if (len > 0 && fmt[len-1] == ':') isLabel = 1;
    else if (len > 2 && fmt[len-2] == ':' && fmt[len-1] == '\n') {
        isLabel = 1;
    }
    if (!isLabel) {
        printf("\t");
    }
    vprintf(fmt, args);
    va_end(args);
}

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
%token ELSE
%token WHILE
%right ASSIGN
%right SC

%%
statementlist    :   statementlist statement | statement;
block            :   LCB statementlist RCB;
conditionE       :   E RELOP E {emit("GT?\n");};
RELOP            :   GT|LT|GE|LE|EQ|UE;
ifstatement      :   IF LP conditionE RP {
    char *Lend = newLabel();
    pushLabel(Lend);
    emit("jnz %s\n", Lend);
    } statement {
        emit("%s:", popLabel());
    };

assignstatement  :   ID ASSIGN E SC {emit("pop %c\n", $1);};
statement        :   assignstatement | ifstatement | block; 

E           :   E ADD E {emit("add\n");}|
                E SUB E|
                E MUL E|
                E DIV E|
                NUMBER {emit("push %d\n", $1);}|
                ID {emit("push %c\n", $1);};
