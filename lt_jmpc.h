
#define JMPC_TABLE_SIZE 0xFFFFF

/*table contenant les instru asm JMPC à compléter*/
typedef struct lt_jmpc_table {
	int last_id;
	int array[JMPC_TABLE_SIZE];
} lt_jmpc_table;


void lt_init_jmpc_table(lt_jmpc_table *table);

int lt_add_jmpc_table(lt_jmpc_table *table, int addr);

int lt_pop_last_jmpc(lt_jmpc_table *table);
