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
int debugMode = 0;
/* Label management */
int labelCount = 0;
char* b_c_stack[MAX_STACK];
int b_c_bot = -1;
int b_c_heapTop = MAX_STACK;
void storeContinueToStack(char *label) {
    if (b_c_bot >= MAX_STACK / 2) {
        printf("b_c Stack overflow\n");
        exit(1);
    }
    b_c_stack[++b_c_bot] = label;
    if (debugMode == 1) printf("label %s moved to b_c_stack [%d]\n", label, b_c_bot);
}
void storeBreakToHeap(char *label) {
    if (b_c_heapTop <= MAX_STACK / 2 - 1) {
        printf("b_c Heap overflow\n");
        exit(1);
    }
    b_c_stack[--b_c_heapTop] = label;
    if (debugMode == 1) printf("label %s moved to b_c_heap [%d]\n", label, b_c_heapTop);
}
char* b_c_popStored(int getEnd) {
    if (getEnd == 1) {
        if (b_c_heapTop >= MAX_STACK) {
            printf("b_c Heap underflow\n");
            exit(1);
        }
        if (debugMode == 1) printf("get element from slot %d\n", b_c_heapTop);
        return b_c_stack[b_c_heapTop++];
    } else {
        if (b_c_bot < 0) {
            printf("Stack underflow\n");
            exit(1);
        }
        if (debugMode == 1) printf("get element from slot %d\n", b_c_bot);
        return b_c_stack[b_c_bot--];
    }
}

/* Head and End management */
char* storedStack[MAX_STACK];
int bot = -1;
int heapTop = MAX_STACK;
void storeStartToStack(char *label) {
    if (bot >= MAX_STACK / 2) {
        printf("Stack overflow\n");
        exit(1);
    }
    storedStack[++bot] = label;
    if (debugMode == 1) printf("label %s moved to %d\n", label, bot);
}
void storeEndToHeap(char *label) {
    if (heapTop <= MAX_STACK / 2 - 1) {
        if (debugMode == 1) printf("Heap overflow\n");
        exit(1);
    }
    storedStack[--heapTop] = label;
    if (debugMode == 1) printf("label %s moved to %d\n", label, heapTop);
}
char* popStored(int getEnd) {
    if (getEnd == 1) {
        if (heapTop >= MAX_STACK) {
            printf("Heap underflow\n");
            exit(1);
        }
        if (debugMode == 1) printf("get element from slot %d\n", heapTop);
        return storedStack[heapTop++];
    } else {
        if (bot < 0) {
            printf("Stack underflow\n");
            exit(1);
        }
        if (debugMode == 1) printf("get element from slot %d\n", bot);
        return storedStack[bot--];
    }
}
char* peekHeap() {return storedStack[heapTop];}
char* peekStack() {return storedStack[bot];}
char* b_c_peekHeap() {return b_c_stack[b_c_heapTop];}
char* b_c_peekStack() {return b_c_stack[b_c_bot];}

char* newLabel() {
    char *buf = malloc(10);
    sprintf(buf, "L%d", labelCount++);
    return buf;
}
/*
emit関数はgptくんに任せました
出力を整える役割です
*/
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
    float fval;    /* for FLOAT */
    char id;      /* for ID (single char variable name) */
    char *sval;   /* for operator strings like "GT?", "LT?" */
}

/* ---------- Tokens ---------- */
/* ---------- %token <id>     ID ---------- */

%token <sval>   ID
%token <ival>   NUMBER
%token <fval>   FLOAT
%token <sval>   GT LT GE LE EQ UE

%token DO IF WHILE FOR CONTINUE BREAK SWITCH CASE DEFAULT COLON
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
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
    : LP conditionE RP  {
          char *L = peekHeap();
          emit("jnz %s\n", L);
      }
    ;
ifheader
    : IF {
          char *L = newLabel();
          storeEndToHeap(L);
      } compareop
    ;

ifstatement
    : ifheader statement %prec LOWER_THAN_ELSE {
          char *Lend = popStored(1);
          emit("%s:\n", Lend); /* Lelse */
      }
    | ifheader /* peekHeap(); jnz(Lelse)*/ statement ELSE {
          char *Lelse = popStored(1);
          char *Lend = newLabel();
          emit("jmp %s\n", Lend); /* jmp Lend */
          emit("%s:\n", Lelse); /* Lelse: */
          storeEndToHeap(Lend);
      } statement {
          char *Lend = popStored(1);
          emit("%s:\n", Lend); /* Lend */
      } 
    ;

whilestatement
    : WHILE {
          char *Lbegin = newLabel();
          char *Lend = newLabel();
          emit("%s:\n", Lbegin);
          storeStartToStack(Lbegin);
          storeEndToHeap(Lend);
          storeContinueToStack(Lbegin);
          storeBreakToHeap(Lend);
      } compareop statement {
          char *Lbegin = b_c_popStored(0);
          char *Lend = b_c_popStored(1);     /* Lelse */
          emit("jmp %s\n", Lbegin); /* Lbegin */
          emit("%s:\n", Lend);
      }
    | DO {
          char *Lbegin = newLabel();
          char *Lend = newLabel();
          emit("%s:\n", Lbegin);
          storeStartToStack(Lbegin);
          storeEndToHeap(Lend);
          storeContinueToStack(Lbegin);
          storeBreakToHeap(Lend);
      } statement WHILE compareop SC {
          char *Lend = b_c_popStored(1);     /* Lend */
          char *Lbegin = b_c_popStored(0);  /* Lbegin */
          emit("jmp %s\n", Lbegin); /*jmp Lbegin */
          emit("%s:\n", Lend);
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
        char *Fend = newLabel();
        emit("%s:\n", Fbegin);
        storeEndToHeap(Fend);
        storeStartToStack(Fbegin);
        storeContinueToStack(Fbegin);
        storeBreakToHeap(Fend);
    } conditionE {
        char *Fend = peekHeap();
        emit("jnz %s\n", Fend);
    } SC forstmtslist RP statement {
        char *Fend = popStored(1);
        char *Fbegin = popStored(0);
        emit("jmp %s\n", Fbegin);
        emit("%s:\n", Fend);
    };

assignstatement
    : ID ASSIGN E SC { emit("pop %s\n", $1); free($1); }
    ;
continuestatement
    : CONTINUE SC {emit("jmp %s\n", b_c_peekStack());}
    ;
breakstatement
    : BREAK SC {emit("jmp %s\n", b_c_peekHeap());}
    ;
statement
    : assignstatement
    | ifstatement
    | whilestatement
    | block
    | forstatement
    | breakstatement
    | continuestatement
    | switchstatement
    ;
switchstatement
    : SWITCH LP E RP {
        char *Lend = newLabel();
        storeBreakToHeap(Lend);
        emit("pop _switch_temp\n");
    } LCB switchbody RCB {
        char *Lend = b_c_popStored(1);
        emit("%s:\n", Lend);
    }
    ;
switchbody
    : caselist optdefault
    | caselist
    ;
caselist
    : caselist caseclause 
    | 
    ;
caseclause
    : CASE NUMBER COLON {
        char *Lnext = newLabel();
        emit("push _switch_temp\n");
        emit("push %d\n", $2);
        emit("EQ?\n");
        emit("jnz %s\n", Lnext);
        storeStartToStack(Lnext);
    } statementlist {
        char *Lnext = popStored(0);
        emit("%s:\n", Lnext);
    }
    ;
optdefault
    : DEFAULT COLON statementlist {
        char *Ldefault = newLabel();
        emit("jmp %s\n", Ldefault);
        emit("%s\n", Ldefault);
    }
    | /* empty */
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
