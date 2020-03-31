package org.xtext.expression.interpreter

import org.xtext.expression.expression.Add
import org.xtext.expression.expression.Calculation
import org.xtext.expression.expression.Div
import org.xtext.expression.expression.Functional
import org.xtext.expression.expression.Mult
import org.xtext.expression.expression.Number
import org.xtext.expression.expression.Parenthesis
import org.xtext.expression.expression.Reference
import org.xtext.expression.expression.Sub
import org.xtext.expression.expression.Variable

class ExpressionInterpreter {
	
	//
	// Compute
	//
	def int compute(Calculation calc) {
		calc.expression.computeExp
	}
	
	def dispatch int computeExp(Add add) {
		return add.left.computeExp + add.right.computeExp
	}
	
	def dispatch int computeExp(Sub sub) {
		return sub.left.computeExp - sub.right.computeExp
	}
	
	def dispatch int computeExp(Mult mult) {
		return mult.left.computeExp * mult.right.computeExp
	}
	
	def dispatch int computeExp(Div div) {
		return div.left.computeExp / div.right.computeExp
	}
	
	def dispatch int computeExp(Functional functional) {
		functional.expression.computeExp
	}
	
	def dispatch int computeExp(Number number) {
		number.value
	}
	
	def dispatch int computeExp(Parenthesis parenthesis) {
		parenthesis.expression.computeExp
	}
	
	def dispatch int computeExp(Reference reference) {
		reference.variable.computeVar
	}
	
	def int computeVar(Variable variable) {
		variable.expression.computeExp
	}
	
	//
	// Display
	//
	def CharSequence display(Calculation calc) '''«calc.name»: «calc.expression.displayExp»'''
	
	def dispatch CharSequence displayExp(Add add) '''«add.left.displayExp» + «add.right.displayExp»'''
	def dispatch CharSequence displayExp(Sub sub) '''«sub.left.displayExp» - «sub.right.displayExp»'''
	def dispatch CharSequence displayExp(Mult mult) '''«mult.left.displayExp» * «mult.right.displayExp»'''
	def dispatch CharSequence displayExp(Div div) '''«div.left.displayExp» / «div.right.displayExp»'''
	def dispatch CharSequence displayExp(Parenthesis parenthesis) '''(«parenthesis.expression.displayExp»)'''
	def dispatch CharSequence displayExp(Number number) '''«number.value»'''
	def dispatch CharSequence displayExp(Functional functional) '''let «functional.variable.displayVar» in «functional.expression.displayExp» end'''
	def dispatch CharSequence displayExp(Reference reference) '''«reference.variable.name»'''
	
	def CharSequence displayDef(Variable variable) '''def «variable.displayVar» with'''
	def CharSequence displayVar(Variable variable) '''«variable.name» = «variable.expression.displayExp»'''
}
