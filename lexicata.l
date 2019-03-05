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
"\t"				 { return tTAB;        }
"\n"				 { /*return tNEWLINE;*/        }
" "					 { return tSPACE;      }
"main" 				 { return tMAIN; }
"const"				 { return tCONST; }
"printf"			 { return tPRINTF;      }
"int"				 { return tINT; }
[\-\+]?[0-9]+e[0-9]+ { return tENTIER; }
[\-\+]?[0-9]+ 		 { return tENTIER; }
[a-zA-Z][a-zA-Z0-9_]* { return tID; }
. 					 { bug();      }


%%

void bug() {
	printf("Error");
}
