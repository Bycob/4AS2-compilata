%{
#include "y.tab.h"

void bug();
%}

%%

"+"                  { return tPLUS;       }
"-"                  { return tMINUS;      }
"*"                  { return tTIMES;      }
"/"                  { return tSLASH;      }
";"                  { return tSEMICOLON;  }
"(" 				 { return tPO; }
")" 				 { return tPF; }
"{"                  { return tAO;      }
"}"                  { return tAF;      }
","                  { return tCOMMA;      }
"."                  { return tPERIOD;     }
"="                  { return tEQL;        }
"<"                  { return tLSS;        }
">"                  { return tGTR;        }
"<="                 { return tLEQ;        }
">="                 { return tGEQ;        }
"\t"				 { /*return tTAB;*/        }
"\n"				 { /*return tNEWLINE;*/        }
" "					 { /*return tSPACE; */     }
"const"				 { return tCONST; }
"printf"			 { return tPRINTF;      }
("int"|"bool"|"char"|"float") { yylval.str = yytext; return tTYPE; }
"if"				 { return tIF; }
"else"				 { return tELSE; }
"while"				 { return tWHILE; }
[\-\+]?[0-9]+e[0-9]+ { yylval.nb = atoi(yytext); return tENTIER; }
[\-\+]?[0-9]+ 		 { yylval.nb = atoi(yytext); return tENTIER; }
[a-zA-Z][a-zA-Z0-9_]* { yylval.str = yytext; return tID; }
. 					 { bug();      }


%%

void bug() {
	printf("Error");
}
