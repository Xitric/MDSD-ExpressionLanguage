# BNF
I did four iterations on the BNF to get from something easily understandable to something that actually adheres to associativity and precedence, and which solves recursion issues.

```c++
// Problem: Left recursive
Exp ::= Exp (Op Exp)? | Lit
Op ::= '+' | '-' | '*' | '/'
Lit ::= INT | '(' Exp ')'

//Problem: Right associative
Exp ::= Lit (Op Exp)?
Op ::= '+' | '-' | '*' | '/'
Lit ::= INT | '(' Exp ')'

// Problem: Wrong operator precedence
Exp ::= Lit (Op Lit)*
Op ::= '+' | '-' | '*' | '/'
Lit ::= INT | '(' Exp ')'

// Problem: None
Exp ::= MultDiv (PMOp MultDiv)*
MultDiv ::= Lit (MDOp Lit)*
Lit ::= '(' Exp ')' | INT
PMOp ::= '+' | '-'
MDOp ::= '*' | '/'
```

# In Xtext
When implementing in Xtext I added the Atomic type to make Lit more focused. I also introduced the PlusMinus rule to be similar to MultDiv:

```
Expression:
	PlusMinus
;

PlusMinus returns Expression:
	MultDiv ({PlusMinus.left=current} operator=PlusMinusOp right=MultDiv)*
;

MultDiv returns Expression:
	Atomic ({MultDiv.left=current} operator=MultDivOp right=Atomic)*
;

Atomic returns Expression:
	'(' Expression ')' | Lit
;

Lit:
	value=INT
;

PlusMinusOp:
	'+' | '-'
;

MultDivOp:
	'*' | '/'
;
```
