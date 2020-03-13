package org.xtext.expression.ui.hover

import static extension org.eclipse.emf.ecore.util.EcoreUtil.*
import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.ui.editor.hover.html.DefaultEObjectHoverProvider
import org.xtext.expression.generator.ExpressionGenerator
import org.xtext.expression.expression.MathExpression
import org.eclipse.emf.ecore.util.Diagnostician

class ExpressionsEObjectHoverProvider extends DefaultEObjectHoverProvider {
	
	@Inject extension ExpressionGenerator
	
	override getHoverInfoAsHtml(EObject obj) {
		val root = obj.rootContainer
		if (root instanceof MathExpression && root.ensureValid) {
			val exp = root as MathExpression
			
			'''
			<p>
			«exp.display» = «exp.compute»
			</p>
			'''
		} else {
			super.getHoverInfoAsHtml(obj)
		}
	}
	
	def ensureValid(EObject obj) {
		Diagnostician.INSTANCE.validate(obj.rootContainer).children.empty
	}
}