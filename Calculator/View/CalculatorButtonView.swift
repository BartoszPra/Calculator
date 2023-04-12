//
//  CalculatorButtonView.swift
//  Calculator
//
//  Created by Bartosz Prazmo on 08/04/2023.
//

import SwiftUI

struct CalculatorButtonView: View {
	
	var button: ButtonViewModel!
	@EnvironmentObject var vm: CalculatorViewModel
	
	var body: some View {
		GeometryReader { bounds in
			Button(action: {
				self.vm.receiveInput(calculatorButton: button)
			}) {
				Text(button.title)
					.foregroundColor(button.textColor)
					.font(.system(size: 32))
					.frame(maxWidth: button.buttonWidth(button: button), maxHeight: button.buttonHeight(), alignment: .center)
					.foregroundColor(.white)
					.background(button.backgroundColor)
					.cornerRadius(button.buttonWidth(button: button))
			}.disabled(!button.isEnabled)
		}
	}
}
