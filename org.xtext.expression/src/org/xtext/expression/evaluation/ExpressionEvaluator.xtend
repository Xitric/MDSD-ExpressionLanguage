package org.xtext.expression.evaluation

import org.xtext.expression.expression.Expression
import org.xtext.expression.expression.PlusMinus
import org.xtext.expression.expression.MultDiv
import org.xtext.expression.expression.Lit

class ExpressionEvaluator {
	
	def int evaluate(Expression expression) {
		return expression.compute;
	}
	
	def dispatch int compute(PlusMinus pm) {
		val left = pm.left.compute
		val right = pm.right.compute
		
		switch (pm.operator) {
			case '+':
				return left + right
			case '-':
				return left - right
			default:
				throw new IllegalStateException('''Unexpected operator in expression: «pm.operator»''')
		}
	}
	
	def dispatch int compute(MultDiv md) {
		val left = md.left.compute
		val right = md.right.compute
		
		switch (md.operator) {
			case '*':
				return left * right
			case '/':
				return left / right
			default:
				throw new IllegalStateException('''Unexpected operator in expression: «md.operator»''')
		}
	}
	
	def dispatch int compute(Lit l) {
		return l.value
	}
}