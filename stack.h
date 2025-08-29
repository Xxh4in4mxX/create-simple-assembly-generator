#ifndef STACK_H
#define STACK_H

typedef struct
{
    int capacity;
    int *stack;
    int top_element;
} Stack;

void initializeStack(Stack *s, int init_capacity);
void upsizeStack(Stack *s);
void downsizeStack(Stack *s);
void push(Stack *s, int value);
int pop(Stack *s);
void freeStack(Stack *s);
#endif
