#include "lt_symbols.h"

#include <string.h>
#include <stdlib.h>
#include <stdio.h>

int lt_sizeof(int type) {
    switch (type) {
        case TYPE_INT: return 4;
        default: return -1;
    }
}

void lt_init_table(lt_symbol_table *table) {
    table->parent_scope = NULL;
    table->last_id = 0;
    table->id_offset = 0;

    for (int i = 0; i < SYMBOL_TABLE_SIZE; ++i) {
        table->array[i].id = -1;
    }
}

void lt_free_table(lt_symbol_table *table) {
    // result
}

int lt_add_symbol(lt_symbol_table *table, int type, char* name) {
    // find id for the new symbol
    int new_id = table->last_id;

    if (new_id >= SYMBOL_TABLE_SIZE) {
        return -1;
    }

    // find address for the new symbol
    int addr = lt_find_last_address(table);

    // add symbol
    table->array[new_id] = (lt_symbol) {
        table->id_offset + new_id, type, addr, strdup(name)
    };
    table->last_id = new_id + 1;
    return 0;
}

lt_symbol *lt_get_symbol_by_id(lt_symbol_table *table, int id) {
    if (id < 0) {
        return NULL;
    }
    else if (id < table->id_offset) {
        return lt_get_symbol_by_id(table->parent_scope, id);
    }
    else {
        return &table->array[id - table->id_offset];
    }
}

lt_symbol *lt_get_symbol_by_name(lt_symbol_table *table, char* name) {
    for (int i = 0 ; i < SYMBOL_TABLE_SIZE ; ++i) {
        lt_symbol *symbol = &table->array[i];

        if (symbol->id != -1 && strcmp(symbol->name, name) == 0) {
            return &table->array[i];
        }
    }

    // if symbol was not found in current scope, look up in parent scope
    if (table->parent_scope != NULL) {
        return lt_get_symbol_by_name(table->parent_scope, name);
    }

    return NULL;
}

lt_symbol *lt_get_last(lt_symbol_table *table) {
    if (table->last_id == 0) {
        if (table->parent_scope == NULL) {
            return NULL;
        }
        else {
            return lt_get_last(table->parent_scope);
        }
    }
    else {
        return &table->array[table->last_id - 1];
    }
}

lt_symbol lt_pop(lt_symbol_table *table) {
    if (table->last_id == 0) {
        lt_symbol ret;
        ret.id = -1;
        return ret;
    }
    else {
        lt_symbol *last = lt_get_last(table);
        lt_symbol result = *last;
        last->id = -1;
        --table->last_id;
        return result;
    }
}

int lt_is_in_table(lt_symbol_table *table, char* name) {
    return lt_get_symbol_by_name(table, name) != NULL;
}

void lt_open_scope(lt_symbol_table **table) {
    lt_symbol_table *new_scope = malloc(sizeof(lt_symbol_table));
    lt_init_table(new_scope);
    new_scope->parent_scope = (*table);
    new_scope->id_offset = new_scope->parent_scope->id_offset + SYMBOL_TABLE_SIZE;
    *table = new_scope;
}

void lt_close_scope(lt_symbol_table **table) {
    if ((*table) == NULL) {
        printf("Cannot close scope of empty table\n");
    }

    lt_symbol_table *parent_scope = (*table)->parent_scope;
    free(*table);
    *table = parent_scope;
}

int lt_find_last_address(lt_symbol_table *table) {
    if (table->last_id == 0) {
        if (table->parent_scope == NULL) {
            return 0;
        }
        else {
            return lt_find_last_address(table->parent_scope);
        }
    }
    else {
        lt_symbol *symbol = &table->array[table->last_id - 1];
        return symbol->addr + lt_sizeof(symbol->type);
    }
}
