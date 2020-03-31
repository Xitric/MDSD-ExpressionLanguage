package org.xtext.expression.ui.hover

import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.util.Diagnostician
import org.eclipse.xtext.ui.editor.hover.html.DefaultEObjectHoverProvider
import org.xtext.expression.expression.Calculation
import org.xtext.expression.expression.Call
import org.xtext.expression.expression.Functional
import org.xtext.expression.expression.Parenthesis
import org.xtext.expression.expression.Reference
import org.xtext.expression.expression.Variable
import org.xtext.expression.interpreter.ExpressionInterpreter

import static extension org.eclipse.emf.ecore.util.EcoreUtil.*

class ExpressionsEObjectHoverProvider extends DefaultEObjectHoverProvider {

	@Inject extension ExpressionInterpreter

	// Not my proudest code, but it works...
	override getHoverInfoAsHtml(EObject obj) {
		if (obj.ensureValid) {
			try {
				if (obj.eAllContents.filter(Call).size > 0) {
					return '''
						<p>
						«obj.displayString»
						</p>
					'''
				} else {
					return '''
						<p>
						«obj.displayString» = «obj.computedValue»
						</p>
					'''
				}
			} catch (UnsupportedOperationException e1) {
				try {
					return '''
						<p>
						«obj.displayString»
						</p>
					'''
				} catch (UnsupportedOperationException e2) {
					super.getHoverInfoAsHtml(obj)
				}
			}
		}
	}

	private def CharSequence getDisplayString(EObject obj) throws UnsupportedOperationException {
		switch (obj) {
			Calculation: obj.display
			Parenthesis,
			Functional: obj.displayExp
			Variable: obj.displayVar
			Reference: obj.variable.name
			default: throw new UnsupportedOperationException("Cannot display " + obj.class.name)
		}
	}

	private def int getComputedValue(EObject obj) throws UnsupportedOperationException {
		switch (obj) {
			Calculation: obj.compute
			Parenthesis,
			Functional: obj.computeExp
			Variable: obj.computeVar
			Reference: obj.computeExp
			default: throw new UnsupportedOperationException("Cannot compute " + obj.class.name)
		}
	}

	private def ensureValid(EObject obj) {
		Diagnostician.INSTANCE.validate(obj.rootContainer).children.empty
	}
}
