# Xtext tiny math interpreter
The interpreter has no left recursion, and implements correct associativity and operator precedence. It also supports functional-style expressions, hovering, scoping, and some validation. Lastly, it is backed by 41 unit tests.

The grammar allows expressions such as the one below, which evaluates to 26:

```
def x = 3 with
def y = x * (1 + 1) with
result is
	let x = (2 + 1) * x - (1 - 1) in
	let x = x + y in
		(x - 2) * 2
end
end
```
