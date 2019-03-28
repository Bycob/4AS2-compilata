
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
	lt_symbol array[SYMBOL_TABLE_SIZE];
} lt_symbol_table;


void lt_init_table(lt_symbol_table *table);

int lt_add_symbol(lt_symbol_table *table, int type, long addr, char* name);

lt_symbol *lt_get_symbol_by_name(lt_symbol_table *table, char* name);

int lt_is_in_table(lt_symbol_table *table, char* name);
