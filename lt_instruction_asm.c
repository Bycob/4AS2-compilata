#include "lt_instruction_asm.h"
#include <string.h>
#include <stdio.h>

char* lt_instru_to_str(int opcode) {
    switch (opcode) {
        case INSTR_NOP:
            return "NOP";
        case INSTR_ADD:
            return "ADD";
        case INSTR_MUL:
            return "MUL";
        case INSTR_SUB:
            return "SUB";
        case INSTR_DIV:
            return "DIV";
        case INSTR_COP:
            return "COP";
        case INSTR_AFC:
            return "AFC";
        case INSTR_LOAD:
            return "LOAD";
        case INSTR_STORE:
            return "STORE";
        case INSTR_EQU:
            return "EQU";
        case INSTR_LSS:
            return "LSS";
        case INSTR_LEQ:
            return "LEQ";
        case INSTR_GTR:
            return "GTR";
        case INSTR_GEQ:
            return "GEQ";
        case INSTR_JMP:
            return "JMP";
        case INSTR_JMPC:
            return "JMPC";
        default:
            return "";
    }
}

void lt_init_asm_table(lt_asm_table *table) {
    table->last_id = 0;

    for (int i = 0; i < ASM_TABLE_SIZE; ++i) {
        table->array[i].r1 = -1;
		table->array[i].r2 = -1;
		table->array[i].r3 = -1;
		table->array[i].instru = INSTR_NOP;
    }
}

int lt_add_asm_table(lt_asm_table *table, short int instru, int r1, int r2, int r3){
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

int lt_get_last_asm_id(lt_asm_table *table) {
    if (table->last_id == 0) {
    	return -1;
    }
    else {
        return table->last_id - 1;
    }
}

void lt_write_asm(lt_asm_table *table, char* filename, int mode) {
    FILE *file = fopen(filename, "w");
    
    for (int i = 0; i < table->last_id; ++i) {
        lt_instru_asm *instru = &table->array[i];
        
        if (mode == WRITE_MODE_TEXT) {
            fprintf(file, "%s %d %d %d\n", lt_instru_to_str(instru->instru), instru->r1, instru->r2, instru->r3);
        }
        else if (mode == WRITE_MODE_BINARY) {
            fwrite((void*)instru, sizeof(*instru), 1, file);
        }
    }
    fclose(file);
}

