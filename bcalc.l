%{
#include <stdlib.h>
#include <stdio.h>
#define MAX_LINE 500
#define MAX_SYMBOL 250
void yyerror(char *);
#include "bcalc.tab.h"
%}
%%
not return NOT;
and return AND;
or return OR;
xor return XOR;
xnor return XNOR;
nand return NAND;
nor return NOR;
[a-z] {
          yylval = *yytext - 'a';
          return VARIABLE;
       }

[0-1]+ {
           yylval = atoi(yytext);
           return BOOLEAN;
        }

[()=\n] { return *yytext; }
[ \t] ;
,  {return *yytext; } 
. yyerror("invalid character");
%%
int yywrap(void) {
return 1;
}
%%
int stack[MAX_LINE];
int top = -1; 

void push(int item)
{

    if (top >= MAX_LINE - 1) {
        printf("stack over flow");
        return;
    }
    else {
        top = top + 1;
        stack[top] = item;
    }
}

int pop()
{
    int item;
    if (top < 0) {
        printf("stack under flow");
    }
    else {
        item = stack[top];
        top = top - 1;
        return item;
    }
}

void EvalPostfix(char postfix[])
{

    int i;
    char ch;
    int val;
    int A, B;

    for (i = 0; postfix[i] != ')'; i++) {
        ch = postfix[i];
        if (isdigit(ch)) {
            push(ch - '0');
        }
        else if (ch == '+' || ch == '-' || ch == '*' || ch == '/') {
            A = pop();
            B = pop();

            switch (ch) 
            {
            case '*':
                val = B * A;
                break;

            case '/':
                val = B / A;
                break;

            case '+':
                val = B + A;
                break;

            case '-':
                val = B - A;
                break;
            }

            push(val);
        }
    }
    printf(" \n Result of expression evaluation : %d \n", pop());
}
int main() {
    char input[MAX_LINE];
    while(fgets(input, MAX_LINE, stdin) != NULL) {
        if (input[0] == '\n') {
            break;
        }
        int len = 0;
        while(input[len] != '\n') {
            len++;
        }
        //printf("%d\n", len);
        char nRawExpression[MAX_LINE][MAX_SYMBOL];
        char nProcessExpression[MAX_LINE];
        int expression = 0;
        int tempCnt = 0;
        for (int i = 0; i < len; i ++) {
            if (input[i] == ' ') {
                tempCnt = 0;
                expression ++;
            } 
            else {
                nRawExpression[expression][tempCnt] = input[i];
                tempCnt ++;
            }
        }
        int result = 0;
        tempCnt = 0;
        expression += 1;
        for (int i = 0; i < expression; i ++) {
            if(strcmp(nRawExpression[i], "TRUE")) {
                nProcessExpression[i] = '1';
    
            }
            else if (strcmp(nRawExpression[i], "FALSE")) {
                nProcessExpression[i] = '0';
            }
            else if (strcmp(nRawExpression[i], "XOR")) {
                nProcessExpression[i] = '^';
            }
            else {
                nProcessExpression[i] = nRawExpression[i];
            }
        }
        for (int i = 0; i < expression; i ++) {
            printf("%c", nProcessExpression[i]);
        }
        printf("\n");
        EvalPostfix(nProcessExpression);
        
    }
}
