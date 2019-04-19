#include "lt_jmpc.h"


void lt_init_jmpc_table(lt_jmpc_table *table){
    table->last_id = 0;

    for (int i = 0; i < JMPC_TABLE_SIZE; ++i) {
        table->array[i] = -1;
    }
}

int lt_add_jmpc_table(lt_jmpc_table *table, int addr){
	// find id for the new instru
    int new_id = table->last_id;

    if (new_id > JMPC_TABLE_SIZE) {
        return -1;
    }
	// add instru
    table->array[new_id] = addr;
    table->last_id = new_id + 1;
    return 0;
};

int lt_pop_last_jmpc(lt_jmpc_table *table) {
    if (table->last_id == 0) {
    	return -1;
    }
    else {
        table->last_id--;
        return table->array[table->last_id];
    }
}
