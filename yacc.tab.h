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
     LP = 260,
     RP = 261,
     LCB = 262,
     RCB = 263,
     ADD = 264,
     SUB = 265,
     DIV = 266,
     MUL = 267,
     GT = 268,
     LT = 269,
     GE = 270,
     LE = 271,
     EQ = 272,
     UE = 273,
     DO = 274,
     IF = 275,
     ELSE = 276,
     WHILE = 277,
     ASSIGN = 278,
     SC = 279
   };
#endif
/* Tokens.  */
#define ID 258
#define NUMBER 259
#define LP 260
#define RP 261
#define LCB 262
#define RCB 263
#define ADD 264
#define SUB 265
#define DIV 266
#define MUL 267
#define GT 268
#define LT 269
#define GE 270
#define LE 271
#define EQ 272
#define UE 273
#define DO 274
#define IF 275
#define ELSE 276
#define WHILE 277
#define ASSIGN 278
#define SC 279




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

