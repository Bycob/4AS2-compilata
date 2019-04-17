#include "lt_instruction_asm.h"
#include <string.h>
#include <stdio.h>

void lt_init_asm_table(lt_asm_table *table) {
    table->last_id = 0;

    for (int i = 0; i < ASM_TABLE_SIZE; ++i) {
        table->array[i].r1 = -1;
		table->array[i].r2 = -1;
		table->array[i].r3 = -1;
		table->array[i].instru = "NOP";
    }
}

int lt_add_asm_table(lt_asm_table *table, char* instru, int r1, int r2, int r3){
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

void lt_init_jmpc_table(lt_jmpc_table *table){
    table->last_id = 0;

    for (int i = 0; i < ASM_TABLE_SIZE; ++i) {
        table->array[i] = -1;
    }
}

int lt_add_jmpc_table(lt_jmpc_table *table, int addr){
	// find id for the new instru
    int new_id = table->last_id;

    if (new_id > ASM_TABLE_SIZE) {
        return -1;
    }
	// add instru
    table->array[new_id] = addr;
    table->last_id = new_id + 1;
    return 0;
};

int lt_get_last_asm_id(lt_asm_table *table) {
    if (table->last_id == 0) {
    	return -1;
    }
    else {
        return table->last_id - 1;
    }
}

int lt_get_last_jmpc_id(lt_jmpc_table *table) {
    if (table->last_id == 0) {
    	return -1;
    }
    else {
        return table->last_id - 1;
    }
}

void lt_write_asm(lt_asm_table *table, char* filename) {
    FILE *file = fopen(filename, "w");

    for (int i = 0; i < table->last_id; ++i) {
        lt_instru_asm *instru = &table->array[i];
        fprintf(file, "%s %d %d %d\n", instru->instru, instru->r1, instru->r2, instru->r3);
    }
    fclose(file);
}

