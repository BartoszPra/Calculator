//
//  DispachQueueMock.swift
//  CalculatorTests
//
//  Created by Bartosz Prazmo on 11/04/2023.
//

import Foundation
import UIKit
@testable import Calculator

final class DispatchQueueMock: DispatchQueueType {
	func async(execute work: @escaping @convention(block) () -> Void) {
		work()
	}
}
