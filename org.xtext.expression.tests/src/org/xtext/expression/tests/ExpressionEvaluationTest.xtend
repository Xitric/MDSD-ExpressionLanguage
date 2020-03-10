package org.xtext.expression.tests

import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import org.xtext.expression.evaluation.ExpressionEvaluator
import org.xtext.expression.expression.Expression

@ExtendWith(InjectionExtension)
@InjectWith(ExpressionInjectorProvider)
class ExpressionEvaluationTest {
	
	@Inject
	extension ParseHelper<Expression> parseHelper
	@Inject
	extension ExpressionEvaluator evaluator
	
	private def void assertValue(CharSequence program, int value) {
		Assertions.assertEquals(program.parse.evaluate, value)
	}
	
	@Test
	def void evaluate_lit() {
		'''
		5
		'''.assertValue(5)
		
	}
	
	@Test
	def void evaluate_plus() {
		'''
		3+5
		'''.assertValue(8)
	}
	
	@Test
	def void evaluate_minus() {
		'''
		8-6
		'''.assertValue(2)
	}
	
	@Test
	def void evaluate_multiply() {
		'''
		5*3
		'''.assertValue(15)
	}
	
	@Test
	def void evaluate_divide() {
		'''
		8/2
		'''.assertValue(4)
	}
	
	@Test
	def void evaluate_multiplyPrecedence() {
		'''
		2+3*5
		'''.assertValue(17)
		
		'''
		3*5+2
		'''.assertValue(17)
	}
	
	@Test
	def void evaluate_dividePrecedence() {
		'''
		2+6/2
		'''.assertValue(5)
		
		'''
		6/2+2
		'''.assertValue(5)
	}
	
	@Test
	def void evaluate_associativity() {
		'''
		2-3-5
		'''.assertValue(-6)
	}
	
	@Test
	def void evaluate_parentheses() {
		'''
		(2+6)/2
		'''.assertValue(4)
		
		'''
		(2+3)*5
		'''.assertValue(25)
	}
	
	@Test
	def void evaluate_onlyParentheses() {
		'''
		(5+6)
		'''.assertValue(11)
	}
	
	@Test
	def void evaluate_complex() {
		'''
		(1+3)*8/2-(2-3)-3-4+2*7
		'''.assertValue(24)
	}
}
