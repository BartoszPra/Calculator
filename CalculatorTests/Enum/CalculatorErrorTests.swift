//
//  CalculatorError.swift
//  CalculatorTests
//
//  Created by Bartosz Prazmo on 11/04/2023.
//

import XCTest
@testable import Calculator

final class CalculatorErrorTests: XCTestCase {

	var sut: CalculatorError!
	
    func testCanReturnCorrectOutputOperantError() throws {
		sut = CalculatorError.operantError
		XCTAssertEqual(sut.localizedDescription, "Please insert valid operant")
    }
	
	func testCanReturnCorrectOutputNumberError() throws {
		sut = CalculatorError.numberError
		XCTAssertEqual(sut.localizedDescription, "Please insert valid number")
	}
	
	func testCanReturnCorrectOutputResultError() throws {
		sut = CalculatorError.resultError
		XCTAssertEqual(sut.localizedDescription, "Invalid calculation result")
	}

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
