
#define INSTR_ADD 0x01
#define INSTR_MUL 0x02
#define INSTR_SOU 0x03
#define INSTR_DIV 0x04
#define INSTR_COP 0x05
#define INSTR_AFC 0x06
#define INSTR_LOAD 0x07
#define INSTR_STORE 0x08
#define INSTR_EQU 0x09
#define INSTR_INF 0xA
#define INSTR_INFE 0xB
#define INSTR_SUP 0xC
#define INSTR_SUPE 0xD
#define INSTR_JMP 0xE
#define INSTR_JMPC 0xF

#define ASM_TABLE_SIZE 0xFFFFF
#define RA 1
#define RB 2
#define RC 3
#define NOARG -1



typedef struct lt_instru_asm {
	char* instru;
	int r1;
	int r2;
	int r3;
} lt_instru_asm;

typedef struct lt_asm_table {
	int last_id;
	lt_instru_asm array[ASM_TABLE_SIZE];
} lt_asm_table;

void lt_init_asm_table(lt_asm_table *table);

int lt_add_asm_table(lt_asm_table *table, char* instru, int r1, int r2, int r3);


