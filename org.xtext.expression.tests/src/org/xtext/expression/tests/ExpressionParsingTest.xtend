/*
 * generated by Xtext 2.20.0
 */
package org.xtext.expression.tests

import com.google.inject.Inject
import org.eclipse.xtext.diagnostics.Severity
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import org.xtext.expression.expression.MathExpression

@ExtendWith(InjectionExtension)
@InjectWith(ExpressionInjectorProvider)
class ExpressionParsingTest {

	@Inject extension ParseHelper<MathExpression>
	@Inject extension ValidationTestHelper validation
	
	private def void assertLegal(CharSequence program) {
		val result = program.parse
		Assertions.assertNotNull(result)
		
		//Parse errors
		val errors = result.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: �errors.join(", ")�''')
		
		//Validation errors
		result.assertNoErrors
	}

	private def void assertIllegal(CharSequence program) {
		//Parse errors
		val result = program.parse
		Assertions.assertFalse(result !== null
			&& result.eResource.errors.isEmpty
			
			//Validation errors
			&& validation.validate(result).forall[severity != Severity.ERROR],
			"Expected errors but found none"
		)
	}

	@Test
	def void parse_empty() {
		'''
		
		'''.assertIllegal
	}
	
	@Test
	def void parse_incompleteResult() {
		'''
		result
		'''.assertIllegal
		
		'''
		is
		'''.assertIllegal
		
		'''
		result is
		'''.assertIllegal
		
		'''
		def result is
		'''.assertIllegal
		
		'''
		def with result is
		'''.assertIllegal
	}
	
	@Test
	def void parse_danglingOperator() {
		'''
		result is 5+
		'''.assertIllegal
		
		'''
		result is +8
		'''.assertIllegal
	}
	
	@Test
	def void parse_illegalParenthesis() {
		'''
		result is (5*9
		'''.assertIllegal
		
		'''
		result is 5*9)
		'''.assertIllegal
		
		'''
		result is ()
		'''.assertIllegal
		
		'''
		result is (2+3*9/)
		'''.assertIllegal
		
		'''
		result is (5*9)(2+7)
		'''.assertIllegal
	}
	
	@Test
	def void parse_onlyLit() {
		'''
		result "a" is 4
		'''.assertLegal
	}
	
	@Test
	def void parse_onlyParenthesis() {
		'''
		result "computation" is (5)
		'''.assertLegal
	}
	
	@Test
	def void parse_correctResult() {
		'''
		result "b" is 2+3/(5*(4-2)/4+6)*(1/2)+9*12/(46-8)
		'''.assertLegal
	}
	
	@Test
	def void parse_incompleteDef() {
		'''
		def
		result is 5
		'''.assertIllegal
		
		'''
		with
		result is 5
		'''.assertIllegal
		
		'''
		def with
		result is 5
		'''.assertIllegal
		
		'''
		def x with
		result is 5
		'''.assertIllegal
		
		'''
		def x = with
		result is 5
		'''.assertIllegal
	}
	
	@Test
	def void parse_forwardReference() {
		'''
		def x = y with
		def y = 1 with
		result is 5
		'''.assertIllegal
	}
	
	@Test
	def void parse_duplicateIdentifiers() {
		'''
		def x = 2 with
		def x = 3 with
		result is 5
		'''.assertIllegal
	}
	
	@Test
	def void parse_missingIdentifier() {
		'''
		def x = y with
		result is x
		'''.assertIllegal
		
		'''
		result is x
		'''.assertIllegal
		
		'''
		result is let x = x * 2 in x end
		'''.assertIllegal
		
		'''
		result is let x = y * 2 in x end
		'''.assertIllegal
		
		'''
		def y = 1 with
		result is let x = y + 2 in z end
		'''.assertIllegal
	}
	
	@Test
	def void parse_incompleteLet() {
		'''
		result is let x in 5 end
		'''.assertIllegal
		
		'''
		result is let x = in 5 end
		'''.assertIllegal
		
		'''
		result is let x = 1 x end
		'''.assertIllegal
		
		'''
		result is let x = 1 in x
		'''.assertIllegal
		
		'''
		result is let x = 1 in end
		'''.assertIllegal
		
		'''
		result is let x = 1 end
		'''.assertIllegal
	}
	
	@Test
	def void parse_variable() {
		'''
		def x = 2 with
		result "c" is x
		'''.assertLegal
	}
	
	@Test
	def void parse_shadowing() {
		'''
		def x = 1 with
		result "num" is let x = x * 2 in x + 2 end
		'''.assertLegal
	}
	
	@Test
	def void parse_correctLetExpression() {
		'''
		result "hey" is 9 * let x = 2 in x * 3 end + 4 / let x = 1 in x + x end
		'''.assertLegal
	}
	
	@Test
	def void parse_unclosedLetExpression() {
		'''
		result is 9 * let x = 2 in x + 4 / let x = 1 in x end
		'''.assertIllegal
	}
	
	@Test
	def void parse_correctMathExpression() {
		'''
		def x = 3 with
		def y = x * (1 + 1) with
		result "comp" is
			let x = (2 + 1) * x - (1 - 1) in
			let x = x + y in
				(x - 2) * 2
		end
		end
		'''.assertLegal
	}
}
