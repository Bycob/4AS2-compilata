
#define SYMBOL_TABLE_SIZE 512
#define TYPE_VOID 0
#define TYPE_INT 1


typedef struct lt_instru_asm {
	char* instru;
	long r1;
	long r2;
	long r3;
} lt_symbol;

char * lt_asm_table;


void lt_init_table(lt_symbol_table *table);

int lt_add_symbol(lt_symbol_table *table, int type, long addr, char* name);

lt_symbol *lt_get_symbol_by_name(lt_symbol_table *table, char* name);

int lt_is_in_table(lt_symbol_table *table, char* name);
