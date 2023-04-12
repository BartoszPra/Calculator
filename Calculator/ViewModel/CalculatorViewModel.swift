//
//  CalcViewModel.swift
//  Calculator
//
//  Created by Bartosz Prazmo on 08/04/2023.
//

import Foundation

class CalculatorViewModel: ObservableObject {
	
	@Published var displayLabel = "0"
	var stringRep: String!
	var value: Int?
	var apiManager: Networking
	var connectionManager: Connecting
	var alertManager: AlertManager
	var isLoading: Bool = false
	var mainDispatchQueue: DispatchQueueType
	private var numberFormatter = NumberFormatter()
	private var scientificNumberFormatter = NumberFormatter()
	private var calculator = Calculator()
	private var inputString = "" {
		didSet {
			buttons[1][0].title = inputString.isEmpty ? "AC" : "C"
		}
	}
	private var inputValue: Double {
		return numberFormatter.number(from: inputString)?.doubleValue ?? 0
	}
	
	init(ApiManager: Networking, AlertManager: AlertManager, ConectionManager: Connecting, mainDispatchQueue: DispatchQueueType = DispatchQueue.main)
	{
		apiManager = ApiManager
		self.mainDispatchQueue = mainDispatchQueue
		alertManager = AlertManager
		connectionManager = ConectionManager
		self.numberFormatter.numberStyle = .decimal
		buttons[5][1].title = numberFormatter.decimalSeparator
		self.scientificNumberFormatter.numberStyle = .scientific
	}
	
	func receiveInput(calculatorButton: ButtonViewModel) {
		
		if !isLoading {
			switch(calculatorButton.type) {
			case .operant:
				operatorTouched(sender: calculatorButton.title)
			case .equals:
				equalTouched()
			case .number:
				numberTouched(sender: calculatorButton.title)
			case .delete:
				allCancelTouched()
			case .separator:
				decimalSeparatorTouched()
			}
		}
	}

	@Published var buttons: [[ButtonViewModel]] = [
		[ButtonViewModel(title: "sin", type: .operant, isEnabled: true),
		 ButtonViewModel(title: "cos", type: .operant, isEnabled: true),
		 ButtonViewModel(title: "B", type: .operant, isEnabled: FeatureToggles.isBitcoinFeatureEnabled)],
		[ButtonViewModel(title: "AC", type: .delete, isEnabled: true),
		 ButtonViewModel(title: "+/-", type: .operant, isEnabled: true),
		 ButtonViewModel(title: "%", type: .operant, isEnabled: true),
		 ButtonViewModel(title: "÷", type: .operant, isEnabled: true)],
		[ButtonViewModel(title: "7", type: .number, isEnabled: true),
		 ButtonViewModel(title: "8", type: .number, isEnabled: true),
		 ButtonViewModel(title: "9", type: .number, isEnabled: true),
		 ButtonViewModel(title: "×", type: .operant, isEnabled: true)],
		[ButtonViewModel(title: "4", type: .number, isEnabled: true),
		 ButtonViewModel(title: "5", type: .number, isEnabled: true),
		 ButtonViewModel(title: "6", type: .number, isEnabled: true),
		 ButtonViewModel(title: "-", type: .operant, isEnabled: true)],
		[ButtonViewModel(title: "1", type: .number, isEnabled: true),
		 ButtonViewModel(title: "2", type: .number, isEnabled: true),
		 ButtonViewModel(title: "3", type: .number, isEnabled: true),
		 ButtonViewModel(title: "+", type: .operant, isEnabled: FeatureToggles.isPlusFeatureEnabled)],
		[ButtonViewModel(title: "0", type: .number, isEnabled: true),
		 ButtonViewModel(title: ".", type: .separator, isEnabled: true),
		 ButtonViewModel(title: "=", type: .equals, isEnabled: true)]
	]
	
	
	
	private var displayValue: Double {
		set {
			let number = NSNumber(floatLiteral: newValue)
			let string = numberFormatter.string(from: number) ?? "0"
			if string.count > 15 {
				displayLabel = scientificNumberFormatter.string(from: number)!
			} else {
				self.displayLabel = string
			}
		}
		get {
			return Double(displayLabel) ?? 0
		}
	}
	
	// MARK: Actions
	
	func numberTouched(sender: String) {
		add(digit: sender)
	}
	
	func allCancelTouched() {
		
		if self.inputString.isEmpty {
			calculator.resetStack()
		}
		
		self.displayLabel = "0"
		self.inputString = ""
	}
	
	func equalTouched() {
		addOperand()
		calculator.reduce()
	}
	
	func decimalSeparatorTouched() {
		if inputString.isEmpty {
			inputString = "0"
		} else {
			inputString = displayLabel
		}
		
		inputString += numberFormatter.decimalSeparator
		displayLabel = inputString
	}
	
	func operatorTouched(sender: String) {
		addOperand()
		switch sender {
		case "+":
			displayValue = calculator.add(Addition())
		case "-":
			displayValue = calculator.add(Subtraction())
		case "÷":
			displayValue = calculator.add(Division())
		case "×":
			displayValue = calculator.add(Multiplication())
		case "+/-":
			displayValue = calculator.add(Negate())
			calculator.reduce()
		case "%":
			displayValue = calculator.add(Percent())
			calculator.reduce()
		case "cos":
			displayValue = calculator.add(Cosinus())
			calculator.reduce()
		case "sin":
			displayValue = calculator.add(Sinus())
			calculator.reduce()
		case "B":
			getBitcoinData()
		default:
			let err = CalculatorError.operantError
			mainDispatchQueue.async {
				self.alertManager.showAlert(title: "Error", message: err.localizedDescription, primaryButtonText: "OK", primaryButtonAction: {}, secondaryButtonText: nil, secondaryButtonAction: nil)
			}
		}
	}
	
	func getBitcoinData() {
		
		if connectionManager.isConnected {
			isLoading = true;
			
			apiManager.fetchBitcoinPrice { [weak self] res in
				switch res {
				case .success(let data):
					if let dta = data {
						guard let price = Double(dta.data.priceUsd) else {return}
						guard let self = self else {return}
						self.mainDispatchQueue.async {
							self.isLoading = false;
							self.displayValue = self.calculator.add(Bitcoin(price: price))
							self.addOperand()
							self.calculator.reduce()
						}
					}
				case .failure(let err):
					self?.mainDispatchQueue.async {
						self?.isLoading = false;
						self?.alertManager.showAlert(title: "Error", message: err.localizedDescription, primaryButtonText: "OK", primaryButtonAction: {}, secondaryButtonText: nil, secondaryButtonAction: nil)
					}
					return
				}
			}
		} else {
			mainDispatchQueue.async {
				self.isLoading = false;
				self.alertManager.showAlert(title: "You are offline", message: "To calculate bitcoin you have to be online!", primaryButtonText: "OK", primaryButtonAction: {}, secondaryButtonText: nil, secondaryButtonAction: nil)
			}
			return
		}
	}
	
	// MARK: Helper
	private func add(digit: String) {
		if inputString.isEmpty {
			inputString = digit
		} else {
			inputString += digit
		}
		
		self.displayValue = inputValue
	}
	
	private func addOperand() {
		if !inputString.isEmpty {
			displayValue = calculator.add(Operand(inputValue))
			inputString = ""
		}
	}
}
