package org.xtext.expression.tests

import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.scoping.IScopeProvider
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.Assert
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import org.xtext.expression.expression.ExpressionPackage
import org.xtext.expression.expression.MathExpression
import org.xtext.expression.expression.Number
import org.xtext.expression.expression.Reference
import org.xtext.expression.expression.Variable

@ExtendWith(InjectionExtension)
@InjectWith(ExpressionInjectorProvider)
class ExpressionScopingTest {
	
	@Inject extension ParseHelper<MathExpression>
	@Inject extension IScopeProvider
	
	def private assertScope(EObject context, EReference reference, Iterable<CharSequence> expected) {
		context.getScope(reference).allElements.map[it.name.toString].iterEquals(expected)
	}
	
	def private <T> iterEquals(Iterable<? extends T> a, Iterable<? extends T> b) {
		Assert.assertTrue('''Expected scope «b» but was «a»''',
			(a.forall[b.contains(it)] && a.size === b.size)
		)
	}
	
	@Test
	def void scope_empty() {
		'''
		result is 5
		'''.parse.expression
			.assertScope(ExpressionPackage.eINSTANCE.reference_Variable,
			#[])
	}
	
	@Test
	def void scope_definitions() {
		'''
		def x = 1 with
		def y = 2 with
		result is x
		'''.parse => [
			definitions.last
				.assertScope(ExpressionPackage.eINSTANCE.reference_Variable,
				#["x"])
			expression
				.assertScope(ExpressionPackage.eINSTANCE.reference_Variable,
				#["x", "y"])
		]
	}
	
	@Test
	def void scope_functional() {
		'''
		result is let x = 0 in x + 2 end
		'''.parse.expression.eAllContents.filter(Reference).head
			.assertScope(ExpressionPackage.eINSTANCE.reference_Variable,
			#["x"])
	}
	
	@Test
	def void scope_backwardReferences() {
		'''
		def x = 1 with
		def y = 2 with
		result is 2 + let z = x + y in z * 6 end
		'''.parse.expression.eAllContents.filter(Reference) => [
			findFirst[variable.name == "x"]
				.assertScope(ExpressionPackage.eINSTANCE.reference_Variable,
				#["x", "y"])
			findFirst[variable.name == "z"]
				.assertScope(ExpressionPackage.eINSTANCE.reference_Variable,
				#["x", "y", "z"])
		]
	}
	
	@Test
	def void scope_forwardReferences() {
		'''
		def x = 1 with
		def y = 2 with
		result is 2 + let z = x + y in z * 6 end
		'''.parse => [
			definitions.last
				.assertScope(ExpressionPackage.eINSTANCE.reference_Variable,
				#["x"])
			expression.eAllContents.filter(Number).head
				.assertScope(ExpressionPackage.eINSTANCE.reference_Variable,
				#["x", "y"])
			expression.eAllContents.filter(Variable).head
				.assertScope(ExpressionPackage.eINSTANCE.reference_Variable,
				#["x", "y"])
		]
	}
	
	@Test
	def void scope_local() {
		'''
		result is let x = 0 in x end + let y = 1 in y * 5 end * 5
		'''.parse.expression.eAllContents => [
			filter(Reference).findFirst[variable.name == "x"]
				.assertScope(ExpressionPackage.eINSTANCE.reference_Variable,
				#["x"])
			filter(Reference).findFirst[variable.name == "y"]
				.assertScope(ExpressionPackage.eINSTANCE.reference_Variable,
				#["y"])
			filter(Number).last
				.assertScope(ExpressionPackage.eINSTANCE.reference_Variable,
				#[])
		]
	}
	
	@Test
	def void scope_parentScope() {
		'''
		def x = 1 with
		result is let y = x + 1 in let z = y * 2 in z / 3 end end
		'''.parse.expression.eAllContents.filter(Reference) => [
			findFirst[variable.name == "y"]
				.assertScope(ExpressionPackage.eINSTANCE.reference_Variable,
				#["x", "y"])
			findFirst[variable.name == "z"]
				.assertScope(ExpressionPackage.eINSTANCE.reference_Variable,
				#["x", "y", "z"])
		]
	}
	
	@Test
	def void scope_shadowing() {
		'''
		def x = 1 with
		result is let x = x + 1 in let x = x * 2 in x / 3 end end
		'''.parse.expression.eAllContents.filter(Reference).forEach [
			assertScope(ExpressionPackage.eINSTANCE.reference_Variable,
			#["x"])
		]
	}
}
