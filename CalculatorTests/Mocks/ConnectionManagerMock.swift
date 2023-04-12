//
//  ConnectionManagerMock.swift
//  CalculatorTests
//
//  Created by Bartosz Prazmo on 11/04/2023.
//

import Foundation
@testable import Calculator

class ConnectionManagerMock : Connecting {
	
	internal init(isConnected: Bool = true, hasStatus: Bool = true) {
		self.isConnected = isConnected
		self.hasStatus = hasStatus
	}

	var isConnected: Bool = true
	var hasStatus: Bool = true
	func checkConnection() {}
}
 
