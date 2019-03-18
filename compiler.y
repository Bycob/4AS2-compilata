%{
    #define YYDEBUG 1

	int yylex(void);
	void yyerror(char*);
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
%type<str> tID

%%
start:Functions;

Functions:Function Functions;
Functions:Function;
Function: Fdecl Body;

Fdecl: tTYPE tID tPO tPF;

Body: tAO Instructions tAF;

Instructions: Instruction Instructions;
Instructions: ;
Instruction: Decl;
Instruction: tPRINTF tPO tID tPF;
Instruction: tIF tPO ExprBool tPF Body tELSE Body;
Instruction: tIF tPO ExprBool tPF Body;
Instruction: tWHILE tPO ExprBool tPF Body;

ExprBool:tID Compare tID;
ExprBool:tENTIER Compare tENTIER;
Compare: tEQL | tLSS | tGTR | tLEQ | tGEQ;

ExprArithm: tID Operator tID;
ExprArithm: ExprArithm Operator tID;
ExprArithm: tID Operator ExprArithm;
ExprArithm: ExprArithm Operator ExprArithm;
Operator:tPLUS | tMINUS;


Decl: tTYPE Aff;
Aff: tID tEQL Expr tSEMICOLON;

Expr: tENTIER;

%%


int main(int argc, char** argv) {
#if YYDEBUG
    yydebug = 0;

    for (int i = 1; i < argc; ++i) {
        if (strcmp(argv[i], "-d") == 0) {
            yydebug = 1;
        }
    }
#endif
    yyparse();
}
