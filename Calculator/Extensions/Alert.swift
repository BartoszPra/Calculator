//
//  Alert.swift
//  Calculator
//
//  Created by Bartosz Prazmo on 10/04/2023.
//

import Foundation
import SwiftUI

extension Alert {
	init(_ alert: AlertManager.Alert) {
		if let sbt = alert.secondaryButtonText {
			self.init(title: Text(alert.title),
					  message: Text(alert.message),
					  primaryButton: .default(Text(alert.primaryButtonText),
											  action: alert.primaryButtonAction),
					  secondaryButton: .cancel(Text(sbt))
			)
		} else {
			self.init(title: Text(alert.title),
					  message: Text(alert.message),
					  dismissButton: .default(Text(alert.primaryButtonText)))
		}
	}
}
