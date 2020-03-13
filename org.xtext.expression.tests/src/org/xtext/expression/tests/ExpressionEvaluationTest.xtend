package org.xtext.expression.tests

import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import org.xtext.expression.expression.MathExpression
import org.xtext.expression.generator.ExpressionGenerator

@ExtendWith(InjectionExtension)
@InjectWith(ExpressionInjectorProvider)
class ExpressionEvaluationTest {
	
	@Inject extension ParseHelper<MathExpression>
	@Inject extension ExpressionGenerator
	
	private def void assertValue(CharSequence program, int value) {
		Assertions.assertEquals(program.parse.compute, value)
	}
	
	@Test
	def void evaluate_lit() {
		'''
		result is 5
		'''.assertValue(5)
		
	}
	
	@Test
	def void evaluate_plus() {
		'''
		result is 3+5
		'''.assertValue(8)
	}
	
	@Test
	def void evaluate_minus() {
		'''
		result is 8-6
		'''.assertValue(2)
	}
	
	@Test
	def void evaluate_multiply() {
		'''
		result is 5*3
		'''.assertValue(15)
	}
	
	@Test
	def void evaluate_divide() {
		'''
		result is 8/2
		'''.assertValue(4)
	}
	
	@Test
	def void evaluate_multiplyPrecedence() {
		'''
		result is 2+3*5
		'''.assertValue(17)
		
		'''
		result is 3*5+2
		'''.assertValue(17)
	}
	
	@Test
	def void evaluate_dividePrecedence() {
		'''
		result is 2+6/2
		'''.assertValue(5)
		
		'''
		result is 6/2+2
		'''.assertValue(5)
	}
	
	@Test
	def void evaluate_associativity() {
		'''
		result is 2-3-5
		'''.assertValue(-6)
	}
	
	@Test
	def void evaluate_parentheses() {
		'''
		result is (2+6)/2
		'''.assertValue(4)
		
		'''
		result is (2+3)*5
		'''.assertValue(25)
	}
	
	@Test
	def void evaluate_onlyParentheses() {
		'''
		result is (5+6)
		'''.assertValue(11)
	}
	
	@Test
	def void evaluate_complex() {
		'''
		result is (1+3)*8/2-(2-3)-3-4+2*7
		'''.assertValue(24)
	}
}
