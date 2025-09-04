/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     ID = 258,
     NUMBER = 259,
     FLOAT = 260,
     GT = 261,
     LT = 262,
     GE = 263,
     LE = 264,
     EQ = 265,
     UE = 266,
     DO = 267,
     IF = 268,
     WHILE = 269,
     FOR = 270,
     CONTINUE = 271,
     BREAK = 272,
     SWITCH = 273,
     CASE = 274,
     DEFAULT = 275,
     COLON = 276,
     LOWER_THAN_ELSE = 277,
     ELSE = 278,
     LP = 279,
     RP = 280,
     LCB = 281,
     RCB = 282,
     CM = 283,
     ADD = 284,
     SUB = 285,
     MUL = 286,
     DIV = 287,
     ASSIGN = 288,
     SC = 289
   };
#endif
/* Tokens.  */
#define ID 258
#define NUMBER 259
#define FLOAT 260
#define GT 261
#define LT 262
#define GE 263
#define LE 264
#define EQ 265
#define UE 266
#define DO 267
#define IF 268
#define WHILE 269
#define FOR 270
#define CONTINUE 271
#define BREAK 272
#define SWITCH 273
#define CASE 274
#define DEFAULT 275
#define COLON 276
#define LOWER_THAN_ELSE 277
#define ELSE 278
#define LP 279
#define RP 280
#define LCB 281
#define RCB 282
#define CM 283
#define ADD 284
#define SUB 285
#define MUL 286
#define DIV 287
#define ASSIGN 288
#define SC 289




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 122 "yacc.y"
{
    int ival;     /* for NUMBER */
    float fval;    /* for FLOAT */
    char id;      /* for ID (single char variable name) */
    char *sval;   /* for operator strings like "GT?", "LT?" */
}
/* Line 1529 of yacc.c.  */
#line 124 "yacc.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

