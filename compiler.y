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
%token tINT
%token tENTIER
%token tID

%%
start:tMAIN;
