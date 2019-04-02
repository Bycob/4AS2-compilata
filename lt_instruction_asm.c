#include "lt_instruction_asm.h"
#include <string.h>


int lt_asm_identify_type(char * type){

	if (!strcmp(type,"void")){
		return 0;
	}
	if (!strcmp(type,"int")){
		return sizeof(int);
	}
}

void lt_init_asm_table(lt_asm_symbol_table *table) {

    for (int i = 0; i < SYMBOL_TABLE_SIZE; ++i) {
        table->array[i].r1 = -1;	
		table->array[i].r2 = -1;
		table->array[i].r3 = -1;
		table->array[i].instru = "NOP";
    }
}

void lt_add_asm_table(lt_asm_symbol_table *table, char* instru, int r1, int r2, int r3){
	// find id for the new symbol
    int new_id = table->last_id;

    if (new_id > SYMBOL_TABLE_SIZE) {
        return -1;
    }
	// add symbol
    table->array[new_id] = (lt_instru_asm) { instru, r1, r2, r3	};
    table->last_id = new_id + 1;
    return 0;
};

