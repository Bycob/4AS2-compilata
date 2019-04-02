
#include "libtest.h"

#include <lt_symbols.h>

int main(int argc, char** argv) {
    lt_symbol_table table;

    lt_init_table(&table);
    assert_true(table.array[SYMBOL_TABLE_SIZE - 1].id == -1, "Table is initialized correctly");

    // Scope
    lt_symbol_table *ptable = &table;
    lt_init_table(ptable);
    lt_open_scope(&ptable);
    assert_true(ptable->array[SYMBOL_TABLE_SIZE - 1].id == -1, "New scope is initialized correctly");
    assert_true(ptable->parent_scope->array[SYMBOL_TABLE_SIZE - 1].id == -1, "New scope is initialized correctly");

    end_test_session();
}
