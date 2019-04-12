#include "libtest.h"

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>

struct test_report;
typedef struct test_report {
    int success;
    struct test_report *next;
} test_report;

test_report *report = NULL;

#define GREEN "\033[32m"
#define RED "\033[31m"
#define END "\033[0m"

void push_report(int success) {
       test_report *new_rep = malloc(sizeof(test_report));
       *new_rep = (test_report) {
           success, report
       };
       report = new_rep;
}

void assert_true(int value, char* message) {
   if (!value) {
       printf("%s-Assert failed: %s%s\n", RED, message, END);
       push_report(false);
   }
   else {
       push_report(true);
   }
}

void end_test_session() {
    int total = 0;
    int passed = 0;

    while (report != NULL) {
        ++total;

        if (report->success) {
            ++passed;
        }

        test_report *newrep = report->next;
        free(report);
        report = newrep;
    }

    if (total == passed) {
        printf("%sAll tests passed! (%d/%d)%s\n", GREEN, passed, total, END);
    }
    else {
        printf("%sSome of the tests failed... (%d/%d)%s\n", RED, passed, total, END);
        exit(-1);
    }
}
