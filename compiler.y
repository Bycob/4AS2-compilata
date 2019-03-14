%{
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
%token tMAIN
%token tCONST
%token tPRINTF
%token tTYPE
%token tENTIER
%token tIF
%token tELSE
%token tWHILE
%token tID

%%
start:Functions;

Functions:Function Functions;
Functions:Function;
Function: Fdecl Body;

Fdecl: tINT tID tPO tPF;

Body: tAO Instructions tAF;

Instructions: Instruction Instructions;
Instructions: ;
Instruction: Decl;
Instruction: tPRINTF tPO tID tPF;
Instruction: tIF tPO Expr tPF Body tELSE Body;
Instruction: tIF tPO Expr tPF Body;
Instruction: tWHILE tPO Expr tPF Body;

Decl: tTYPE Aff;
Aff: tID tEQL Expr tSEMICOLON;

Expr: tENTIER;
