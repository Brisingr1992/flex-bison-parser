# A simple parser with flex and bison

To run this program type `make` and then run `./calc`. Use `make clean` to clean all the junk files.

This program follows the context free grammer defined by these rules:
`
Prog -> main() {Vardefs; Stmts} Vardefs -> ε | Vardef; Vardefs
Vardef -> int Id | float Id
Stmts -> ε | Stmt; Stmts
Stmt -> Id = E | printID Id | printExp E
E -> Integer | Float | Id | E - E | E * E | E / E | E + E
Integer -> digit+
Float -> Integer . Integer | Integer”E”Integer | Float”E”Integer
`

### Grammer

*Prog* defines a program that contains only one function main().

*Vardefs* is a sequence of variable declarations. A program may or may not have variable declarations. ε specifies empty variable declarations. Each variable Id is either a positive integer (int Id) or a positive floating point (float Id).
• A positive integer is a sequence of digits from 0 to 9, e.g. 2, 96.
• A positive floating point number is a decimal point (e.g. 2.16), or an integer/decimal point followed
by an optional integer exponent part (e.g., 1.5E2). The character 'E' separates the mantissa and expo- nent parts. E.g. `1.5E2 (1.5*10 ^ 2) and 2E5 (2*10^5)` are valid floating points.

*Stmts* is a sequence of statements. A program may or may not have statements. ε specifies empty statement.

*Id* is an identifier, which starts with a lower-case letter and followed by 0 or more lower-case letters, capital letters, or digits. For example, x, x1, xy, xY, x12Z are identifiers, but 1x and A1 are not. int Id defines an integer variable. A new integer variable gets 0 as its initial value. float Id defines a floating point variable. A new floating point variable gets 0.0 as its initial value.

*Expression* E is a floating point, an identifier, or an infix arithmetic expression with operators. These two operators are left associative (e.g., 1 - 2 - 3 is equivalent to (1 - 2) - 3). `* / has higher precedence than + -`

Id = E assigns the value of an expression E to the variable Id. printID Id prints the value of Id. printExp E prints the value of an expression E.

If an input does not match any token, output `lexical error: <input>`, where <input> is the input.
If there is an syntax error, line number for the error is printed

###### Also there is a simple demonstration of semantics via symbol table using a simple linked list and there is type checking also.

###### I made this project for an assignment and putting this up for the people who need a quick reference for flex and bison implementation.