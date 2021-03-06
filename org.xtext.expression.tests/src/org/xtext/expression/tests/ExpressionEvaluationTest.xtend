package org.xtext.expression.tests

import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import org.xtext.expression.expression.MathExpression
import org.xtext.expression.interpreter.ExpressionInterpreter

@ExtendWith(InjectionExtension)
@InjectWith(ExpressionInjectorProvider)
class ExpressionEvaluationTest {
	
	@Inject extension ParseHelper<MathExpression>
	@Inject extension ExpressionInterpreter
	
	private def void assertValue(CharSequence program, int value) {
		val expression = program.parse;
		
		if (expression.calculations.size == 0) {
			Assertions.fail("No calculations to evaluate")
		} else if (expression.calculations.size > 1) {
			Assertions.fail("Calculation is ambiguous")
		} else {
			Assertions.assertEquals(value, expression.calculations.get(0).compute)
		}
	}
	
	@Test
	def void evaluate_lit() {
		'''
		result "a" is 5
		'''.assertValue(5)
		
	}
	
	@Test
	def void evaluate_plus() {
		'''
		result "b" is 3+5
		'''.assertValue(8)
	}
	
	@Test
	def void evaluate_minus() {
		'''
		result "c" is 8-6
		'''.assertValue(2)
	}
	
	@Test
	def void evaluate_multiply() {
		'''
		result "d" is 5*3
		'''.assertValue(15)
	}
	
	@Test
	def void evaluate_divide() {
		'''
		result "e" is 8/2
		'''.assertValue(4)
	}
	
	@Test
	def void evaluate_multiplyPrecedence() {
		'''
		result "f" is 2+3*5
		'''.assertValue(17)
		
		'''
		result "g" is 3*5+2
		'''.assertValue(17)
	}
	
	@Test
	def void evaluate_dividePrecedence() {
		'''
		result "h" is 2+6/2
		'''.assertValue(5)
		
		'''
		result "i" is 6/2+2
		'''.assertValue(5)
	}
	
	@Test
	def void evaluate_associativity() {
		'''
		result "j" is 2-3-5
		'''.assertValue(-6)
	}
	
	@Test
	def void evaluate_parentheses() {
		'''
		result "k" is (2+6)/2
		'''.assertValue(4)
		
		'''
		result "l" is (2+3)*5
		'''.assertValue(25)
	}
	
	@Test
	def void evaluate_onlyParentheses() {
		'''
		result "m" is (5+6)
		'''.assertValue(11)
	}
	
	@Test
	def void evaluate_complexResult() {
		'''
		result "n" is (1+3)*8/2-(2-3)-3-4+2*7
		'''.assertValue(24)
	}
	
	@Test
	def void evaluate_variable() {
		'''
		def x = 2 with
		result "o" is x
		'''.assertValue(2)
	}
	
	@Test
	def void evaluate_functionalExpression() {
		'''
		def x = 5 with
		result "p" is let y = x + 1 in y end
		'''.assertValue(6)
	}
	
	@Test
	def void evaluate_shadowing() {
		'''
		def x = 5 with
		result "q" is let x = x + 1 in x end
		'''.assertValue(6)
	}
	
	@Test
	def void parse_correctLetExpression() {
		'''
		result "r" is 9 * let x = 2 in x * 3 end + 4 / let x = 1 in x + x end
		'''.assertValue(56)
		
		'''
		def x = 8 with
		def y = (x * 6) / 5 - 3 + let z = x * 3 in z + 2 end with
		result "s" is y * x
		'''.assertValue(256)
	}
	
	@Test
	def void evaluate_complexFunctionalExpression() {
		'''
		def x = 3 with
		def y = x * (1 + 1) with
		result "t" is
			let x = (2 + 1) * x - (1 - 1) in
			let x = x + y in
				(x - 2) * 2
		end
		end
		'''.assertValue(26)
	}
}
