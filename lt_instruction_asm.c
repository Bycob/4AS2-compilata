#include "lt_instruction_asm.h"
#include <string.h>

void lt_init_asm_table(lt_asm_table *table) {

    for (int i = 0; i < ASM_TABLE_SIZE; ++i) {
        table->array[i].r1 = -1;	
		table->array[i].r2 = -1;
		table->array[i].r3 = -1;
		table->array[i].instru = "NOP";
    }
}

void lt_add_asm_table(lt_asm_table *table, char* instru, int r1, int r2, int r3){
	// find id for the new instru
    int new_id = table->last_id;

    if (new_id > ASM_TABLE_SIZE) {
        return -1;
    }
	// add instru
    table->array[new_id] = (lt_instru_asm) { instru, r1, r2, r3	};
    table->last_id = new_id + 1;
    return 0;
};

