/*
  Symbol table defines a linked list which on runtime is used to hold
  the values and types of the identifiers declared in the program.

  void push(): Use this to create a new linked list with a identifier
               name, type and default value
    Example: int x will save id as x, type as 'i' (short for integer)
             and a default value of 0 for x

  table * last_element(): Returns the the last member in the chain of
                          .linked lists

  table * search(): Returns the linked list by identifier name else it
                    returns a NULL pointer.  
*/

struct symbolTable {
  char * id;
  char type;
  union {
    int ival;
    float fval;
  } value;

  struct symbolTable *next;
};

typedef struct symbolTable table;
extern table *tableptr;

void push(char * id, char type);
table * last_element();
table * search(char * name);