//
//  AlertManager.swift
//  Calculator
//
//  Created by Bartosz Prazmo on 10/04/2023.
//

import Foundation

class AlertManager {

	@Published var shouldShowAlert = false

	var alert: Alert? = nil {
		didSet {
			shouldShowAlert = alert != nil
		}
	}
	
	struct Alert {
		var title: String
		var message: String
		var primaryButtonText: String
		var primaryButtonAction: (() -> Void)?
		var secondaryButtonText: String?
		var secondaryButtonAction: (() -> Void)?
	}
	
	func showAlert(title: String,message: String, primaryButtonText: String, primaryButtonAction: (() -> Void)?, secondaryButtonText: String?, secondaryButtonAction: (() -> Void)?) {
		alert = AlertManager.Alert(
			title: title,
			message: message,
			primaryButtonText: primaryButtonText,
			primaryButtonAction: primaryButtonAction,
			secondaryButtonText: secondaryButtonText,
			secondaryButtonAction: secondaryButtonAction
		)
	}
}
