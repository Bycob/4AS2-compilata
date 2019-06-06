%{
	#include <string.h>
	#include <stdio.h>

	#include "lt_symbols.h"
	#include "lt_instruction_asm.h"
	#include "lt_jmpc.h"

    #define YYDEBUG 1

	lt_symbol_table *ref_symbols;
	lt_asm_table *ref_asm;
	lt_jmpc_table *ref_jmpc;

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
%token tAFF
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

%type<nb> Body
%type<nb> Compare
%type<nb> Operator
%type<nb> tENTIER
%type<str> tID Aff
%type<str> tTYPE

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
		$$ = lt_get_last_asm_id(ref_asm) + 1;
	};

/* Fonctions */

Functions:Function Functions | Function;
Function: Fdecl Body;
Fdecl: tTYPE tID tPO tPF {
    // printf("%p\n", ref_symbols);
};

Instructions: Instruction Instructions | ;
Instruction: InstructionBody tSEMICOLON
    | IfBlock
	| IfElseBlock
    | WhileBlock;

InstructionBody: Decl | DeclAff | Aff
    | tPRINTF tPO tID tPF;

IfHeader: tIF tPO ExprBool tPF {
		lt_add_asm_table(ref_asm, INSTR_LOAD, RA, lt_pop(ref_symbols).addr, NOARG);
		lt_add_asm_table(ref_asm, INSTR_JMPC, -1, RA, NOARG);
		lt_add_jmpc_table(ref_jmpc, lt_get_last_asm_id(ref_asm));
	};

IfBlock: IfHeader Body {
		ref_asm->array[lt_pop_last_jmpc(ref_jmpc)].r1 = $2;
	};

IfElseBlock: IfHeader Body {
		lt_add_asm_table(ref_asm, INSTR_JMP, -1, NOARG, NOARG);
		// jmpc destination is `end of body address + 1` because we added a jmp at the end of the body
		ref_asm->array[lt_pop_last_jmpc(ref_jmpc)].r1 = $2 + 1;
		lt_add_jmpc_table(ref_jmpc, lt_get_last_asm_id(ref_asm));
	} tELSE Body {
		ref_asm->array[lt_pop_last_jmpc(ref_jmpc)].r1 = $5;
	};
	
WhileBlock: tWHILE { $<nb>$ = lt_get_last_asm_id(ref_asm); } tPO ExprBool tPF {
		lt_add_asm_table(ref_asm, INSTR_LOAD, RA, lt_pop(ref_symbols).addr, NOARG);
		lt_add_asm_table(ref_asm, INSTR_JMPC, -1, RA, NOARG);
		lt_add_jmpc_table(ref_jmpc, lt_get_last_asm_id(ref_asm));
	} Body {
		lt_add_asm_table(ref_asm, INSTR_JMP, $<nb>2, NOARG, NOARG);
		// +1 because we added an instruction
		ref_asm->array[lt_pop_last_jmpc(ref_jmpc)].r1 = $7 + 1;
	};

/* Expressions */

Expr: ExprBool | ExprArithm;

ExprBool: ExprArithm Compare ExprArithm {
		lt_add_asm_table(ref_asm, INSTR_LOAD, RB, lt_pop(ref_symbols).addr, NOARG);
		lt_add_asm_table(ref_asm, INSTR_LOAD, RA, lt_get_last(ref_symbols)->addr, NOARG);
		lt_add_asm_table(ref_asm, $2, RA, RA, RB);
		lt_add_asm_table(ref_asm, INSTR_STORE, lt_get_last(ref_symbols)->addr, RA, NOARG);
	};

Compare: tEQL {
		$$ = INSTR_EQU;
	}
	| tLSS {
		$$ = INSTR_LSS;
	}
	| tGTR {
		$$ = INSTR_GTR;
	}
	| tLEQ {
		$$ = INSTR_LEQ;
	}
	| tGEQ {
		$$ = INSTR_GEQ;
	};

ExprArithm: tID
	{
		lt_check_error_notdeclared(ref_symbols,$1);
		lt_add_symbol(ref_symbols,TYPE_INT, "");
		lt_add_asm_table(ref_asm, INSTR_LOAD, RA, lt_get_symbol_by_name(ref_symbols, $1)->addr, NOARG);
		lt_add_asm_table(ref_asm, INSTR_STORE, lt_get_last(ref_symbols)->addr, RA, NOARG);
	}
    | tENTIER
	{
		lt_add_symbol(ref_symbols,TYPE_INT, "");
		lt_add_asm_table(ref_asm, INSTR_AFC, RA, $1, NOARG);
		lt_add_asm_table(ref_asm, INSTR_STORE, lt_get_last(ref_symbols)->addr, RA, NOARG);
	}
    | ExprArithm Operator ExprArithm
	{
		lt_add_asm_table(ref_asm, INSTR_LOAD, RB, lt_pop(ref_symbols).addr, NOARG);
		lt_add_asm_table(ref_asm, INSTR_LOAD, RA, lt_get_last(ref_symbols)->addr, NOARG);
		lt_add_asm_table(ref_asm, $2, RA, RA, RB);
		lt_add_asm_table(ref_asm, INSTR_STORE, lt_get_last(ref_symbols)->addr, RA, NOARG);
	};

Operator: tPLUS {
		$$ = INSTR_ADD;
	}
	| tMINUS {
		$$ = INSTR_SUB;
	}
	| tTIMES {
		$$ = INSTR_MUL;
	}
	| tSLASH {
		$$ = INSTR_DIV;
	};

/* Declaration instruction */

Decl: tTYPE tID {
	lt_check_error_declared(ref_symbols,$2, $1);
	lt_add_symbol(ref_symbols, lt_identify_type($1), $2);
};

DeclAff: tTYPE tID tAFF Expr {
	lt_pop(ref_symbols);
	lt_add_symbol(ref_symbols, lt_identify_type($1), $2);
};

Aff: tID tAFF Expr {
	lt_check_error_notdeclared(ref_symbols,$1);
	lt_add_asm_table(ref_asm, INSTR_LOAD, RA, lt_pop(ref_symbols).addr, NOARG);
	int addr = lt_get_symbol_by_name(ref_symbols, $1)->addr;
	lt_add_asm_table(ref_asm, INSTR_STORE, addr, RA, NOARG);
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

    // Init jmpc table
	ref_jmpc = malloc(sizeof(lt_jmpc_table));
	lt_init_jmpc_table(ref_jmpc);

    // Parse
    yyparse();

	lt_write_asm(ref_asm, "b.out", WRITE_MODE_TEXT);

	free(ref_symbols);
	free(ref_asm);
}
