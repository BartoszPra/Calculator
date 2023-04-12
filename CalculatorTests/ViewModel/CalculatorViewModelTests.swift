//
//  CalculatorViewModelTests.swift
//  CalculatorViewModelTests
//
//  Created by Bartosz Prazmo on 07/04/2023.
//

import XCTest
@testable import Calculator

final class CalculatorViewModelTests: XCTestCase {

	var sut: CalculatorViewModel!
	
    override func setUpWithError() throws {
		sut = CalculatorViewModel(ApiManager: NetworkManagerMock(isSuccess: true, errorType: .noData), AlertManager: AlertManager(), ConectionManager: ConnectionManagerMock(isConnected: true, hasStatus: true), mainDispatchQueue: DispatchQueueMock())
    }

    override func tearDownWithError() throws {
		sut = nil
    }

    func testCanCreateCorrectNumberOfButtons() throws {
		XCTAssertEqual(sut.buttons.count, 6)
		XCTAssertEqual(sut.buttons[0].count, 3)
		XCTAssertEqual(sut.buttons[1].count, 4)
		XCTAssertEqual(sut.buttons[2].count, 4)
		XCTAssertEqual(sut.buttons[3].count, 4)
		XCTAssertEqual(sut.buttons[3].count, 4)
		XCTAssertEqual(sut.buttons[4].count, 4)
		XCTAssertEqual(sut.buttons[5].count, 3)
		
    }
	
	func testCanProduceCorrectNumberOutput() throws {
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "1", type: .number, isEnabled: true))
		XCTAssertEqual(sut.displayLabel, "1")
	}
	
	func testCanProduceCorrectOutputResetStack() throws {
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "AC", type: .delete, isEnabled: true))
		XCTAssertEqual(sut.displayLabel, "0")
	}
	
	func testCanProduceCorrectOutputOperantOnEmpty() throws {
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "+", type: .operant, isEnabled: FeatureToggles.isPlusFeatureEnabled))
		XCTAssertEqual(sut.displayLabel, "0")
	}
	
	func testCanProduceCorrectDeleteAllOutput() throws {
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "AC", type: .delete, isEnabled: true))
		XCTAssertEqual(sut.displayLabel, "0")
	}
	
	func testCanProduceCorrectCalculationOutputPlus() throws {
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "2", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "+", type: .operant, isEnabled: FeatureToggles.isPlusFeatureEnabled))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "3", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "=", type: .equals, isEnabled: true))
		XCTAssertEqual(sut.displayLabel, "5")
	}
	
	func testCanProduceCorrectCalculationOutputMinus() throws {
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "2", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "-", type: .operant, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "3", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "=", type: .equals, isEnabled: true))
		XCTAssertEqual(sut.displayLabel, "-1")
	}
	
	func testCanProduceCorrectCalculationOutputDivide() throws {
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "9", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "0", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "÷", type: .operant, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "5", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "=", type: .equals, isEnabled: true))
		XCTAssertEqual(sut.displayLabel, "18")
	}
	
	func testCanProduceCorrectCalculationOutputNegate() throws {
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "2", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "8", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "+/-", type: .operant, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "+", type: .operant, isEnabled: FeatureToggles.isPlusFeatureEnabled))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "3", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "0", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "=", type: .equals, isEnabled: true))
		XCTAssertEqual(sut.displayLabel, "2")
	}
	
	func testCanProduceCorrectCalculationOutputPercentage() throws {
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "2", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "%", type: .operant, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "×", type: .operant, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "2", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "=", type: .equals, isEnabled: true))
		XCTAssertEqual(sut.displayLabel, "0.04")
	}
	
	func testCanProduceCorrectCalculationOutputCos() throws {
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "3", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "6", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "0", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "cos", type: .operant, isEnabled: true))
		XCTAssertEqual(sut.displayLabel, "1")
	}
	
	func testCanProduceCorrectCalculationOutputSin() throws {
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "9", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "0", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "sin", type: .operant, isEnabled: true))
		XCTAssertEqual(sut.displayLabel, "1")
	}
	
	func testCanProduceCorrectCalculationOutputSeparator() throws {
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "2", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: ".", type: .separator, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "5", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "×", type: .operant, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "2", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "=", type: .equals, isEnabled: true))
		XCTAssertEqual(sut.displayLabel, "5")
	}
	
	func testCanProduceCorrectCalculationOutputSeparatorWhenEmpty() throws {
		sut.receiveInput(calculatorButton: ButtonViewModel(title: ".", type: .separator, isEnabled: true))
		XCTAssertEqual(sut.displayLabel, "0.")
	}
	
	func testCanProduceCorrectCalculationOutputClear() throws {
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "2", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "5", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "C", type: .delete, isEnabled: true))
		XCTAssertEqual(sut.displayLabel, "0")
	}
	
	func testCanProduceCorrectCalculationOutputBitcoinSuccess() throws {
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "1", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "B", type: .operant, isEnabled: true))
		XCTAssertEqual(sut.displayLabel, "30,215.063")
	}
	
	func testCanProduceCorrectCalculationOutputBitcoinFailureTrErr() throws {
		sut.apiManager = NetworkManagerMock(isSuccess: false, errorType: NetworkError.transportError(NSError()))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "1", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "B", type: .operant, isEnabled: true))
		XCTAssertEqual(sut.displayLabel, "1")
		XCTAssertEqual(sut.alertManager.shouldShowAlert, true)
	}
	
	func testCanProduceCorrectCalculationOutputBitcoinFailureNoDataErr() throws {
		sut.apiManager = NetworkManagerMock(isSuccess: false, errorType: NetworkError.noData)
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "1", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "B", type: .operant, isEnabled: true))
		XCTAssertEqual(sut.displayLabel, "1")
		XCTAssertEqual(sut.alertManager.shouldShowAlert, true)
	}
	
	func testCanProduceCorrectCalculationOutputBitcoinFailureStCodeErr() throws {
		sut.apiManager = NetworkManagerMock(isSuccess: false, errorType: NetworkError.serverError(statusCode: 500))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "1", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "B", type: .operant, isEnabled: true))
		XCTAssertEqual(sut.displayLabel, "1")
		XCTAssertEqual(sut.alertManager.shouldShowAlert, true)
	}
	
	func testCanProduceCorrectCalculationOutputBitcoinFailureDecodeErr() throws {
		sut.apiManager = NetworkManagerMock(isSuccess: false, errorType: NetworkError.encodingError(NSError()))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "1", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "B", type: .operant, isEnabled: true))
		XCTAssertEqual(sut.displayLabel, "1")
		XCTAssertEqual(sut.alertManager.shouldShowAlert, true)
	}
	
	func testCanProduceCorrectCalculationOutputBitcoinFailureEncodeErr() throws {
		sut.apiManager = NetworkManagerMock(isSuccess: false, errorType: NetworkError.decodingError(NSError()))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "1", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "B", type: .operant, isEnabled: true))
		XCTAssertEqual(sut.displayLabel, "1")
		XCTAssertEqual(sut.alertManager.shouldShowAlert, true)
	}
	
	func testCanProduceCorrectCalculationOutputBitcoinFailure() throws {
		sut.apiManager = NetworkManagerMock(isSuccess: false, errorType: NetworkError.transportError(NSError()))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "1", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "B", type: .operant, isEnabled: true))
		XCTAssertEqual(sut.displayLabel, "1")
		XCTAssertEqual(sut.alertManager.shouldShowAlert, true)
	}
	
	func testCanProduceCorrectCalculationOutputBitcoinNoConnection() throws {
		sut.connectionManager = ConnectionManagerMock(isConnected: false)
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "1", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "B", type: .operant, isEnabled: true))
		XCTAssertEqual(sut.displayLabel, "1")
		XCTAssertEqual(sut.alertManager.shouldShowAlert, true)
	}
	
	func testCanProduceCorrectCalculationOutputInvalidOperant() throws {
		sut.connectionManager = ConnectionManagerMock(isConnected: false)
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "1", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "k", type: .operant, isEnabled: true))
		XCTAssertEqual(sut.displayLabel, "1")
		XCTAssertEqual(sut.alertManager.shouldShowAlert, true)
	}
	
	func testCanProduceCorrectCalculationOutputLongNumber() throws {
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "9", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "9", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "9", type: .number, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "B", type: .operant, isEnabled: true))
		sut.receiveInput(calculatorButton: ButtonViewModel(title: "B", type: .operant, isEnabled: true))
		XCTAssertEqual(sut.displayLabel, "9.120370524505137E11")
	}
	
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
