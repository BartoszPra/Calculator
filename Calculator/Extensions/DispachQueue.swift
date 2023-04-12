//
//  DspachQueue.swift
//  Calculator
//
//  Created by Bartosz Prazmo on 11/04/2023.
//

import Foundation

protocol DispatchQueueType {
	func async(execute work: @escaping @convention(block) () -> Void)
}

extension DispatchQueue: DispatchQueueType {
	func async(execute work: @escaping @convention(block) () -> Void) {
		async(group: nil, qos: .unspecified, flags: [], execute: work)
	}
}
