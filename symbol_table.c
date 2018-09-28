#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol_table.h"

table *tableptr;

void push(char * name, char type) {
  table * last = NULL;

  // Assign identifier values to the new struct
  table * new = malloc(sizeof(table));
  new -> id = name;
  new -> type = type;
  new -> next = NULL;

  if (type == 'i') new -> value.ival = 0;
  else new -> value.fval = 0.0;

  if (tableptr == NULL)
    tableptr = new;
  else {
    last = last_element();
    last -> next = new;
  }
}

table * last_element() {
  if (tableptr == NULL) return NULL;
  if (tableptr -> next == NULL) return tableptr;

  table * head = tableptr;
  while(head -> next != NULL) {
    head = head -> next;
  }

  return head;
}

table * search(char * name) {
  if (!tableptr) return NULL;

  table * current = tableptr;
  while(current != NULL) {
    int compare = strcmp(current -> id, name);

    if (compare == 0) return current;
    current = current -> next;
  }

  return current;
}