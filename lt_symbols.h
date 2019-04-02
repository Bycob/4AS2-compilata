#ifndef LT_SYMBOLS_H
#define LT_SYMBOLS_H

#define SYMBOL_TABLE_SIZE 512
#define TYPE_VOID 0
#define TYPE_INT 1

int lt_sizeof(int type);


struct lt_symbol_table;

typedef struct lt_symbol {
	int id;
	int type;
	long addr;
	char* name;
} lt_symbol;

typedef struct lt_symbol_table {
	int id_offset;
	int last_id;
    struct lt_symbol_table *parent_scope;
	lt_symbol array[SYMBOL_TABLE_SIZE];
} lt_symbol_table;


void lt_init_table(lt_symbol_table *table);

void lt_free_table(lt_symbol_table *table);

/** Add a symbol in the table inside of the current scope. If the table
is full, symbol is not added and this function returns -1. */
int lt_add_symbol(lt_symbol_table *table, int type, char* name);

lt_symbol *lt_get_symbol_by_id(lt_symbol_table *table, int id);

lt_symbol *lt_get_symbol_by_name(lt_symbol_table *table, char* name);

/** Get the last symbol of the table, ie the one with the highest id. */
lt_symbol *lt_get_last(lt_symbol_table *table);

/** Delete the last symbol of the table (with the highest id) and return it.  */
lt_symbol lt_pop(lt_symbol_table *table);

int lt_is_in_table(lt_symbol_table *table, char* name);

void lt_open_scope(lt_symbol_table **table);

void lt_close_scope(lt_symbol_table **table);

/** Get address after the last symbol of the table. */
int lt_find_last_address(lt_symbol_table *table);

#endif // LT_SYMBOLS_H
