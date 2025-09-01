%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "stack.h"

#define MAX_STACK 100

/* Prototypes */
void yyerror(const char *s);
int yyparse(void);
int yylex(void);

/* Label management */
int labelCount = 0;
char* labelStack[MAX_STACK];
int top = -1;

char* newLabel() {
    char *buf = malloc(10);
    sprintf(buf, "L%d", labelCount++);
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

/* formatting & white-space pruning */
void emit(const char *fmt, ...) {
    va_list args;
    va_start(args, fmt);

    size_t len = strlen(fmt);
    int isLabel = 0;
    if (len > 0 && fmt[len-1] == ':') isLabel = 1;
    else if (len > 2 && fmt[len-2] == ':' && fmt[len-1] == '\n') isLabel = 1;

    if (!isLabel) printf("\t");
    vprintf(fmt, args);

    va_end(args);
}
%}

/* ---------- Semantic values ---------- */
%union {
    int ival;     /* for NUMBER */
    char id;      /* for ID (single char variable name) */
    char *sval;   /* for operator strings like "GT?", "LT?" */
}

/* ---------- Tokens ---------- */
/* ---------- %token <id>     ID ---------- */

%token <sval>   ID
%token <ival>   NUMBER
%token <sval>   GT LT GE LE EQ UE

%token DO IF ELSE WHILE FOR
%token LP RP LCB RCB CM
%token ADD SUB MUL DIV
%token ASSIGN SC

/* ---------- Precedences ---------- */
%left ADD SUB
%left MUL DIV
%right ASSIGN

/* ---------- Non-terminals ---------- */
%type <ival> E
%type <sval> relop

%%

statementlist
    : statementlist statement
    | statement
    ;

block
    : LCB statementlist RCB
    ;

conditionE
    : E relop E { emit("%s\n", $2); }
    ;

relop
    : GT { $$ = $1; }
    | LT { $$ = $1; }
    | GE { $$ = $1; }
    | LE { $$ = $1; }
    | EQ { $$ = $1; }
    | UE { $$ = $1; }
    ;

compareop
    : LP conditionE RP {
          char *Lelse = newLabel();
          pushLabel(Lelse);
          emit("jnz %s\n", Lelse);
      }
    ;

ifstatement
    : IF compareop statement ELSE {
          char *Lend = newLabel();
          emit("jmp %s\n", Lend);
          emit("%s:\n", popLabel()); /* Lelse */
          pushLabel(Lend);
      } statement {
          emit("%s:\n", popLabel()); /* Lend */
      }
    | IF compareop statement {
          emit("%s:\n", popLabel()); /* Lelse */
      }
    ;

whilestatement
    : WHILE {
          char *Lbegin = newLabel();
          emit("%s:\n", Lbegin);
          pushLabel(Lbegin);
      } compareop statement {
          char *end = popLabel();     /* Lelse */
          emit("jmp %s\n", popLabel()); /* Lbegin */
          emit("%s:\n", end);
      }
    | DO {
          char *Lbegin = newLabel();
          emit("%s:\n", Lbegin);
          pushLabel(Lbegin);
      } statement WHILE compareop SC {
          char *end = popLabel();     /* Lelse */
          emit("jmp %s\n", popLabel()); /* Lbegin */
          emit("%s:\n", end);
      }
    ;
forassign
    : ID ASSIGN E { emit("pop %s\n", $1); free($1); }
    ;
forstmts
    : forassign
    ;
forstmtslist
    : forstmts CM forstmtslist
    | forstmts
    ;
forstatement
    : FOR LP assignstatement {
        char *Fbegin = newLabel();
        emit("%s:\n", Fbegin);
        pushLabel(Fbegin);
    } conditionE {
        char *Fout = newLabel();
        emit("jnz %s\n", Fout);
        pushLabel(Fout);
    } SC forstmtslist RP statement {
        char *Fout = popLabel();
        emit("jmp %s\n", popLabel());
        emit("%s:\n", Fout);
    }; 

assignstatement
    : ID ASSIGN E SC { emit("pop %s\n", $1); free($1); }
    ;

statement
    : assignstatement
    | ifstatement
    | whilestatement
    | block
    | forstatement
    ;



E
    : E ADD E { emit("add\n"); }
    | E SUB E { emit("sub\n"); }
    | E MUL E { emit("mul\n"); }
    | E DIV E { emit("div\n"); }
    | NUMBER  { emit("push %d\n", $1); }
    | ID      { emit("push %s\n", $1); }
    ;

%%

