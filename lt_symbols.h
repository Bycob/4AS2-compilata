
#define SYMBOL_TABLE_SIZE 512
#define TYPE_VOID 0
#define TYPE_INT 1

struct lt_symbol_table;

typedef struct lt_symbol {
	int id;
	int type;
	long addr;
	char* name;
} lt_symbol;

typedef struct lt_symbol_table {
	int last_id;
    struct lt_symbol_table *parent_scope;
	lt_symbol array[SYMBOL_TABLE_SIZE];
} lt_symbol_table;


void lt_init_table(lt_symbol_table *table);

/** Add a symbol in the table inside of the current scope. If the table
is full, symbol is not added and this function returns -1. */
int lt_add_symbol(lt_symbol_table *table, int type, long addr, char* name);

lt_symbol *lt_get_symbol_by_name(lt_symbol_table *table, char* name);

int lt_is_in_table(lt_symbol_table *table, char* name);

void lt_open_scope(lt_symbol_table **table);

void lt_close_scope(lt_symbol_table **table);
