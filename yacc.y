%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "stack.h"
    void yyerror(const char *s);
    int yyparse(void);
    int yylex();
    int iflabel = 0;
    int yylex(void);
void initializeStack(Stack *s, int init_capacity)
{
    s->stack = (int *)malloc(init_capacity * sizeof(int));
    s->capacity = init_capacity;
    s->top_element = -1;
}
void upsizeStack(Stack *s) {
    if (s->top_element + 1 == s->capacity) {
        s->capacity *= 2;
        s->stack = (int *)realloc(s->stack, s->capacity * sizeof(int));
        printf("upped, current size %d\n", s->capacity);
    }
    else
        return;
}
void downsizeStack(Stack *s) {
    if (s->top_element + 1 < s->capacity / 2) {
        s->capacity /= 2;
        s->stack = (int *)realloc(s->stack, s->capacity * sizeof(int));
        printf("downed, current size %d\n", s->capacity);
    } else
        return;
}
void push(Stack *s, int value)
{
    upsizeStack(s);
    s->top_element++;
    s->stack[s->top_element] = value;
}
int pop(Stack *s)
{
    downsizeStack(s);
    if (s->top_element >= 0)
    {
        return s->stack[s->top_element--];
    }
    else
    {
        printf("Stack pop error!\n");
        exit(1);
    }
}
void freeStack(Stack *s)
{
    free(s->stack);
    s->stack = NULL;
    s->capacity = 0;
    s->top_element = -1;
}

    Stack label_index;
    Stack *ptr_to_stack = &label_index;
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
ifstatement      :   IF LP conditionE RP {
    
    
    initializeStack(ptr_to_stack, 5);
    push(ptr_to_stack, ++iflabel);
    printf("\tjnz ENDIF%d\n", iflabel);
    }
    statement {
        printf("ENDIF%d\n", pop(ptr_to_stack));
    };

assignstatement  :   ID ASSIGN E SC {printf("\tPOP %c\n", $1);};
statement        :   assignstatement | ifstatement | block; 

E           :   E ADD E {printf("\tADD\n");}|
                E SUB E|
                E MUL E|
                E DIV E|
                NUMBER {printf("\tpush %d\n", $1);}|
                ID {printf("\tpush %c\n", $1);};
