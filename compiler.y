%{
	#include <string.h>

    #define YYDEBUG 1

	#define TYPE_VOID 0
	#define TYPE_INT 1

	typedef struct lt_symbol {
		int id;
		int type;
		long addr;
		char* name;
	} lt_symbol;

	#define SYMBOL_TABLE_SIZE 512

	struct lt_symbol_table;

	typedef struct lt_symbol_table {
		int last_id;
		lt_symbol array[SYMBOL_TABLE_SIZE];
	} lt_symbol_table;


	lt_symbol_table *ref_symbols;

	int yylex(void);
	void yyerror(char*);

	void init_table(lt_symbol_table *table);
	int add_symbol(lt_symbol_table *table, int type, long addr, char* name);
	lt_symbol *get_symbol_by_name(lt_symbol_table *table, char* name);

	/*..exceptions in rulata..*/
	int is_in_table(lt_symbol_table *table, char* name);
	void error_declare1(lt_symbol_table *table, char* name1, char* name2);
	void error_declare2(lt_symbol_table *table, char* name1, char* name2);
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

%%
start:Functions;

Functions:Function Functions;
Functions:Function;
Function: Fdecl Body;

Fdecl: tTYPE tID tPO tPF { 
printf("%x\n", ref_symbols);
error_declare2(ref_symbols,$2,$2);
};

Body: tAO Instructions tAF;

Instructions: Instruction Instructions;
Instructions: ;
Instruction: Decl;
Instruction: ExprArithm;
Instruction: tPRINTF tPO tID tPF  {
error_declare1(ref_symbols,$3,$3);
};
Instruction: tIF tPO ExprBool tPF Body tELSE Body;
Instruction: tIF tPO ExprBool tPF Body;
Instruction: tWHILE tPO ExprBool tPF Body;

ExprBool:Decl Compare Decl;
ExprBool:tID Compare tID {
error_declare1(ref_symbols,$1,$3);
};
ExprBool:tENTIER Compare tENTIER /*{
	if (!is_in_table(ref_symbols,$1)||!is_in_table(ref_symbols,$3)) {
		printf("exception var not declared\n");
	}
	else if (!is_int($1)||!is_int($3))  {
		printf("exception var not int\n");
	}	
}*/;
Compare: tEQL | tLSS | tGTR | tLEQ | tGEQ;

ExprArithm: tID Operator tID {
error_declare1(ref_symbols,$1,$3);
};
ExprArithm: ExprArithm Operator ExprArithm;
Operator:tPLUS | tMINUS;


Decl: tTYPE Aff  {
error_declare2(ref_symbols,$1,$1);
};
Aff: tID tEQL Expr tSEMICOLON {

	$$ = $1;
};

Expr: tENTIER;

%%

void init_table(lt_symbol_table *table) {
    for (int i = 0; i < SYMBOL_TABLE_SIZE; ++i) {
        table->array[i].id = -1;
    }
}

int add_symbol(lt_symbol_table *table, int type, long addr, char* name) {
    // find id for the new symbol
    int new_id = table->last_id;

    if (new_id > SYMBOL_TABLE_SIZE) {
        return -1;
    }

    // add symbol
    table->array[new_id] = (lt_symbol) {
        new_id, type, addr, name
    };
    table->last_id = new_id + 1;
    return 0;
}

lt_symbol *get_symbol_by_name(lt_symbol_table *table, char* name) {
    for (int i = 0 ; i < SYMBOL_TABLE_SIZE ; ++i) {
        lt_symbol *symbol = &table->array[i];

        if (symbol->id != -1 && strcmp(symbol->name, name) == 0) {
            return &table->array[i];
        }
    }
    return NULL;
}

/*..exceptions in rulata..*/
int is_in_table(lt_symbol_table *table, char* name) {
    return get_symbol_by_name(table, name) != NULL;
}

void error_declare1(lt_symbol_table *table, char* name1, char* name2){
	if (!is_in_table(table,name1) || !is_in_table(table,name2)) {
		printf("exception var not declared\n");
	}
}
void error_declare2(lt_symbol_table *table, char* name1, char* name2){
	if (is_in_table(table,name1) || is_in_table(table,name2)) {
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
    lt_symbol_table symbols;
    init_table(&symbols);
    ref_symbols = &symbols;

    // Parse
    yyparse();
}
