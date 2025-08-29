#include <stdio.h>
#include <stdlib.h>
#include "stack.h"
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
/*
int main() {
    Stack a;
    Stack *ptr_to_a = &a;
    initializeStack(ptr_to_a, 10);
    push(ptr_to_a, 1);
    push(ptr_to_a, 2);
    push(ptr_to_a, 3);
    push(ptr_to_a, 4);
    push(ptr_to_a, 5);
    push(ptr_to_a, 6);
    push(ptr_to_a, 7);
    push(ptr_to_a, 8);
    push(ptr_to_a, 9);
    push(ptr_to_a, 10);
    push(ptr_to_a, 11);
    push(ptr_to_a, 12);
    push(ptr_to_a, 13);
    push(ptr_to_a, 14);
    push(ptr_to_a, 15);
    push(ptr_to_a, 16);
    printf("%d popped from stack\n", pop(ptr_to_a));
    printf("%d popped from stack\n", pop(ptr_to_a));
    printf("%d popped from stack\n", pop(ptr_to_a));
    printf("%d popped from stack\n", pop(ptr_to_a));
    printf("%d popped from stack\n", pop(ptr_to_a));
    printf("%d popped from stack\n", pop(ptr_to_a));
    printf("%d popped from stack\n", pop(ptr_to_a));
    printf("%d popped from stack\n", pop(ptr_to_a));

    printf("%d popped from stack\n", pop(ptr_to_a));
    printf("%d popped from stack\n", pop(ptr_to_a));
    printf("%d popped from stack\n", pop(ptr_to_a));
    printf("%d popped from stack\n", pop(ptr_to_a));

    printf("%d popped from stack\n", pop(ptr_to_a));
    printf("%d popped from stack\n", pop(ptr_to_a));
    printf("%d popped from stack\n", pop(ptr_to_a));
    printf("%d popped from stack\n", pop(ptr_to_a));
    freeStack(ptr_to_a);
    return 0;
}
*/
