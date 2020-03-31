package org.xtext.expression.ui.hover

import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.util.Diagnostician
import org.eclipse.xtext.ui.editor.hover.html.DefaultEObjectHoverProvider
import org.xtext.expression.expression.Functional
import org.xtext.expression.expression.Parenthesis
import org.xtext.expression.expression.Reference
import org.xtext.expression.expression.Variable
import org.xtext.expression.interpreter.ExpressionInterpreter

import static extension org.eclipse.emf.ecore.util.EcoreUtil.*
import org.xtext.expression.expression.Calculation

class ExpressionsEObjectHoverProvider extends DefaultEObjectHoverProvider {
	
	@Inject extension ExpressionInterpreter
	
	override getHoverInfoAsHtml(EObject obj) {
		if (obj.ensureValid) {
			switch (obj) {
				Calculation:
					'''
					<p>
					«obj.display» = «obj.compute»
					</p>
					'''
				Parenthesis,
				Functional:
					'''
					<p>
					«obj.displayExp» = «obj.computeExp»
					</p>
					'''
				Variable:
					'''
					<p>
					«obj.displayVar» = «obj.computeVar»
					</p>
					'''
				Reference:
					'''
					<p>
					«obj.variable.name» = «obj.computeExp»
					</p>
					'''
				default: super.getHoverInfoAsHtml(obj)
			}
		}
	}
	
	def ensureValid(EObject obj) {
		Diagnostician.INSTANCE.validate(obj.rootContainer).children.empty
	}
}
