//
//  ConnectionManager.swift
//  Calculator
//
//  Created by Bartosz Prazmo on 10/04/2023.
//

import Foundation
import Network

protocol Connecting {
	var isConnected: Bool {get set}
	var hasStatus: Bool {get set}
	func checkConnection()
}

class ConnectionManager: Connecting {
	
	init() {
		checkConnection();
	}
	
	let monitor = NWPathMonitor()
	let queue = DispatchQueue(label: "Monitor")
	@Published var isConnected: Bool = false
	internal var hasStatus: Bool = false
	
	func checkConnection() {
		monitor.pathUpdateHandler = { path in
			// this is to improve the function to work on simulator
			#if targetEnvironment(simulator)
				if (!self.hasStatus) {
					self.isConnected = path.status == .satisfied
					self.hasStatus = true
				} else {
					self.isConnected = !self.isConnected
				}
			#else
				self.isConnected = path.status == .satisfied
			#endif
			print("isConnected: " + String(self.isConnected))
		}
		monitor.start(queue: queue)
	}
}
