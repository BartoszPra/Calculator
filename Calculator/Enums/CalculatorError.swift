//
//  CalculatorError.swift
//  Calculator
//
//  Created by Bartosz Prazmo on 11/04/2023.
//

import Foundation

enum CalculatorError: Error {
	case operantError
	case numberError
	case resultError
}

extension CalculatorError: LocalizedError {
	
	var errorDescription: String? {
		switch self {
		case .operantError:
			return "Please insert valid operant"
		case .numberError:
			return "Please insert valid number"
		case .resultError:
			return "Invalid calculation result"
		}
	}
}
