#include "lt_symbols.h"

#include <string.h>


void lt_init_table(lt_symbol_table *table) {
    for (int i = 0; i < SYMBOL_TABLE_SIZE; ++i) {
        table->array[i].id = -1;
    }
}

int lt_add_symbol(lt_symbol_table *table, int type, long addr, char* name) {
    // find id for the new symbol
    int new_id = table->last_id;

    if (new_id > SYMBOL_TABLE_SIZE) {
        return -1;
    }

    // add symbol
    table->array[new_id] = (lt_symbol) {
        new_id, type, addr, name
    };
    table->last_id = new_id + 1;
    return 0;
}

lt_symbol *lt_get_symbol_by_name(lt_symbol_table *table, char* name) {
    for (int i = 0 ; i < SYMBOL_TABLE_SIZE ; ++i) {
        lt_symbol *symbol = &table->array[i];

        if (symbol->id != -1 && strcmp(symbol->name, name) == 0) {
            return &table->array[i];
        }
    }
    return NULL;
}

// exceptions in rulata
int lt_is_in_table(lt_symbol_table *table, char* name) {
    return lt_get_symbol_by_name(table, name) != NULL;
}
