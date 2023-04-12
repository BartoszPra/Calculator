//
//  CalculatorButton.swift
//  Calculator
//
//  Created by Bartosz Prazmo on 07/04/2023.
//

import Foundation
import SwiftUI

struct ButtonViewModel: Hashable {
	
	let id = UUID()
	var title: String
	var type: CalculatorButtonType
	var isEnabled: Bool = true
	
	var opac: Double {
		return isEnabled ? 1 : 0
	}
	var textColor: Color { return Color.white.opacity(opac)}
	var backgroundColor: Color {
		if isEnabled {
			switch self.type {
			case .number, .separator:
				return Color(.darkGray)
			case .delete:
				return Color(.lightGray)
			case .operant, .equals:
				return Color.theme.operantColor
			}
		} else {
			return Color.white.opacity(0)
		}
	}
	
	func buttonHeight() -> CGFloat {
		let height = UIScreen.main.bounds.size.width
		//print("Button width:  \(height)")
		return (height - 5 * 12) / 4
	}
	
	func buttonWidth(button: ButtonViewModel) -> CGFloat {
		let width = UIScreen.main.bounds.size.width
		if button.title == "0" {
			print("Button 0!!! width: \((width - 4 * 12) / 4 * 2)")
			return (width - 4 * 12) / 4 * 2
		}
		print("Button width:  \((width - 5 * 12) / 4)")
		return (width - 5 * 12) / 4
	}
}
