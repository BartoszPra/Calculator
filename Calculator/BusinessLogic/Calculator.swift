//
//  Calculator.swift
//  Calculator
//
//  Created by Bartosz Prazmo on 08/04/2023.
//

import Foundation

protocol Token {}

// MARK: - Calculator

struct Calculator {
	
	private var stack: [Token] = []
	
	mutating func add(_ token: Token) -> Double {
		if !stack.isEmpty && stack.last is Operator == token is Operator {
			_ = self.stack.removeLast()
		}
		
		stack.append(token)
		print(stack)
		return Calculator.eval(stack).value
	}
	
	mutating func reduce() {
		self.stack = [Calculator.eval(self.stack)]
		print(stack)
	}
	
	mutating func resetStack() {
		self.stack = []
	}
	
	static func eval(_ stack: [Token]) -> Operand {
		guard !stack.isEmpty else { return Operand(0) }
		guard stack.first is Operand else { return Operand(0) }
		
		if stack.count == 1 {
			if let result = stack.first as? Operand {
				return result
			} else {
				return Operand(0)
			}
		} else {
			var stack = stack
			let operand = stack.removeFirst() as! Operand
			let next = stack.removeFirst()
			if let unaryOperator = next as? UnaryOperator {
				return eval([unaryOperator.eval(operand)] + stack)
			} else if let additiveOperator = next as? AdditiveOperator {
				return additiveOperator.eval(a: operand, b: eval(stack))
			} else if let multiplicativeOperator = next as? MultiplicativeOperator {
				let secondOperand = stack.isEmpty
					? Operand(1)
					: stack.removeFirst() as? Operand ?? Operand(1)
				return eval([multiplicativeOperator.eval(a: operand, b: secondOperand)] + stack)
			}
		}
		return Operand(0)
	}
}

// MARK: - Operand

struct Operand: Token {
	let value: Double
	
	init(_ value: Double) {
		self.value = value
	}
}

// MARK: - Operator

protocol Operator: Token {}

protocol UnaryOperator: Operator {
	func eval(_ operand: Operand) -> Operand
}

struct Negate: UnaryOperator {
	func eval(_ operand: Operand) -> Operand{
		return Operand(-operand.value)
	}
}

struct Percent: UnaryOperator {
	func eval(_ operand: Operand) -> Operand {
		return Operand(operand.value * 0.01)
	}
}

struct Bitcoin: UnaryOperator {
	var price: Double
	init(price: Double) {
		self.price = price
	}
	func eval(_ operand: Operand) -> Operand {
		return Operand(operand.value * price)
	}
}

struct Cosinus: UnaryOperator {
	func eval(_ operand: Operand) -> Operand {
		return Operand(__cospi(operand.value/180.0))
	}
}

struct Sinus: UnaryOperator {
	func eval(_ operand: Operand) -> Operand {
		return Operand(__sinpi(operand.value/180.0))
	}
}

protocol BinaryOperator: Operator {
	func eval(a: Operand, b: Operand) -> Operand
}

protocol MultiplicativeOperator: BinaryOperator {}

struct Multiplication: MultiplicativeOperator {
	func eval(a: Operand, b: Operand) -> Operand {
		return Operand(a.value * b.value)
	}
}

struct Division: MultiplicativeOperator {
	func eval(a: Operand, b: Operand) -> Operand {
		return Operand(a.value / b.value)
	}
}

protocol AdditiveOperator: BinaryOperator {}

struct Addition: AdditiveOperator {
	func eval(a: Operand, b: Operand) -> Operand {
		return Operand(a.value + b.value)
	}
}

struct Subtraction: AdditiveOperator {
	func eval(a: Operand, b: Operand) -> Operand {
		return Operand(a.value - b.value)
	}
}
