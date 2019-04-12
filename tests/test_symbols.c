
#include "libtest.h"

#include <string.h>

#include <lt_symbols.h>

void test_get_by_id() {
    
}

void test_get_last_and_pop() {
    lt_symbol_table table;
    lt_symbol_table *ptable = &table;
    lt_symbol *last;
    lt_init_table(ptable);

    lt_add_symbol(ptable, TYPE_INT, "");
    lt_add_symbol(ptable, TYPE_INT, "");
    lt_add_symbol(ptable, TYPE_INT, "du");

    last = lt_get_last(ptable);
    assert_true(strcmp(last->name, "du") == 0, "get_last");
    assert_true(last->addr == 8, "get_last address");
    assert_true(lt_find_last_address(ptable) == 12, "find_address");

    lt_open_scope(&ptable);

    last = lt_get_last(ptable);
    assert_true(strcmp(last->name, "du") == 0, "get_last after opening scope");
    assert_true(last->addr == 8, "get_last address after opening scope");
    assert_true(lt_find_last_address(ptable) == 12, "find_address after opening scope");

    lt_add_symbol(ptable, TYPE_INT, "da");
    lt_add_symbol(ptable, TYPE_INT, "");

    last = lt_get_last(ptable);
    assert_true(strcmp(last->name, "") == 0, "get_last in child scope");
    assert_true(last->addr == 16, "get_last address in child scope");
    assert_true(lt_find_last_address(ptable) == 20, "find_address in child scope");

    lt_symbol popped = lt_pop(ptable);
    last = lt_get_last(ptable);
    assert_true(popped.addr == 16, "popped item address");
    assert_true(strcmp(last->name, "da") == 0, "get_last after pop");
    assert_true(lt_find_last_address(ptable) == 16, "find_address after pop");
}

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

    test_get_last_and_pop();

    end_test_session();
}
