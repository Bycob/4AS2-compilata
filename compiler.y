%{
	#include <string.h>
	#include <stdio.h>

	#include "lt_symbols.h"
	#include "lt_instruction_asm.h"

    #define YYDEBUG 1

	lt_symbol_table *ref_symbols;
	lt_asm_table *ref_asm;

	int yylex(void);
	void yyerror(char*);

	int lt_identify_type(char * type);

	/* exceptions in rulata */
	void lt_check_error_notdeclared(lt_symbol_table *table, char* name);
	void lt_check_error_declared(lt_symbol_table *table, char* name, char* type);
%}

%token tPLUS
%token tMINUS
%token tTIMES
%token tSLASH
%token tSEMICOLON
%token tPO
%token tPF
%token tAO
%token tAF
%token tCOMMA
%token tPERIOD
%token tEQL
%token tLSS
%token tGTR
%token tLEQ
%token tGEQ
%token tTAB
%token tNEWLINE
%token tSPACE
%token tCONST
%token tPRINTF
%token tTYPE
%token tENTIER
%token tIF
%token tELSE
%token tWHILE
%token tID

%union {
    int nb;
    char* str;
}

%type<nb> tENTIER
%type<str> tID Aff
%type<str> tTYPE
%type<nb> Expr

%%
start:Functions;

/* General */

Body:
	tAO
	{
		lt_open_scope(&ref_symbols);
	}
	Instructions tAF
	{
		lt_close_scope(&ref_symbols);
	};

/* Fonctions */

Functions:Function Functions | Function;
Function: Fdecl Body;
Fdecl: tTYPE tID tPO tPF {
    printf("%p\n", ref_symbols);
};

Instructions: Instruction Instructions | ;
Instruction: InstructionBody tSEMICOLON
    | tIF tPO ExprBool tPF Body tELSE Body
    | tIF tPO ExprBool tPF Body
    | tWHILE tPO ExprBool tPF Body;

InstructionBody: Decl | DeclAff | Aff
    | tPRINTF tPO tID tPF;

/* Expressions */

Expr: ExprBool | ExprArithm;

ExprBool: ExprArithm Compare ExprArithm;

Compare: tEQL | tLSS | tGTR | tLEQ | tGEQ;

ExprArithm: tID {
		lt_check_error_notdeclared(ref_symbols,$1);
		lt_add_symbol(ref_symbols,TYPE_INT, "");
		lt_add_asm_table(ref_asm, "LOAD", RA, lt_get_symbol_by_name(ref_symbols, $1)->addr, NOARG);
		lt_add_asm_table(ref_asm, "STORE", lt_get_last(ref_symbols)->addr, RA, NOARG); }
    | tENTIER{
		lt_add_symbol(ref_symbols,TYPE_INT, "");
		lt_add_asm_table(ref_asm, "AFC", RA, $1, NOARG);
		lt_add_asm_table(ref_asm, "STORE", lt_get_last(ref_symbols)->addr, RA, NOARG);
}
    | ExprArithm tPLUS ExprArithm {
		lt_add_asm_table(ref_asm, "LOAD", RA, lt_pop(ref_symbols).addr, NOARG);
		lt_add_asm_table(ref_asm, "LOAD", RB, lt_get_last(ref_symbols)->addr, NOARG);
		lt_add_asm_table(ref_asm, "ADD", RA, RA, RB);
		lt_add_asm_table(ref_asm, "STORE", lt_get_last(ref_symbols)->addr, RA, NOARG);
}
	| ExprArithm tMINUS ExprArithm {
		lt_add_asm_table(ref_asm, "LOAD", RA, lt_pop(ref_symbols).addr, NOARG);
		lt_add_asm_table(ref_asm, "LOAD", RB, lt_get_last(ref_symbols)->addr, NOARG);
		lt_add_asm_table(ref_asm, "SOU", RA, RA, RB);
		lt_add_asm_table(ref_asm, "STORE", lt_get_last(ref_symbols)->addr, RA, NOARG);
};


/* Declaration instruction */

Decl: tTYPE tID {
	lt_check_error_declared(ref_symbols,$2, $1);
};

DeclAff: tTYPE tID tEQL Expr {
	lt_pop(ref_symbols);
	lt_add_symbol(ref_symbols, lt_identify_type($1), $2);
};

Aff: tID tEQL Expr {
	lt_check_error_notdeclared(ref_symbols,$1);
	lt_add_asm_table(ref_asm, "LOAD", RA, lt_pop(ref_symbols).addr, NOARG);
	int addr = lt_get_symbol_by_name(ref_symbols, $1)->addr;
	lt_add_asm_table(ref_asm, "STORE", addr, RA, NOARG);
};


//Expr: tENTIER;
%%

int lt_identify_type(char * type){

	if (!strcmp(type,"void")){
		return TYPE_VOID;
	}
	if (!strcmp(type,"int")){
		return TYPE_INT;
	}
	else
		return -1;
}

/* exceptions in rulata */
void lt_check_error_notdeclared(lt_symbol_table *table, char* name){
	if (!lt_is_in_table(table,name)) {
		printf("exception var not declared\n");
	}
}

void lt_check_error_declared(lt_symbol_table *table, char* name, char* type){
	if (lt_is_in_table(table,name)) {
		printf("exception var already declared\n");
	}
}


int main(int argc, char** argv) {
#if YYDEBUG
    yydebug = 0;

    for (int i = 1; i < argc; ++i) {
        if (strcmp(argv[i], "-d") == 0) {
            yydebug = 1;
        }
    }
#endif

    // Init symbol table
	ref_symbols = malloc(sizeof(lt_symbol_table));
    lt_init_table(ref_symbols);

    // Init asm_instru table
	ref_asm = malloc(sizeof(lt_asm_table));
	lt_init_asm_table(ref_asm);

    // Parse
    yyparse();

	lt_write_asm(ref_asm, "b.out");

	free(ref_symbols);
	free(ref_asm);
}
