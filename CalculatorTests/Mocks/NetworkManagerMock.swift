//
//  NetworkManagerMock.swift
//  CalculatorTests
//
//  Created by Bartosz Prazmo on 11/04/2023.
//

import Foundation
@testable import Calculator

class NetworkManagerMock: Networking {
	
	var isSuccess: Bool
	var errorType: NetworkError
	
	init(isSuccess: Bool, errorType: NetworkError) {
		self.isSuccess = isSuccess
		self.errorType = errorType
	}

	func fetchBitcoinPrice(completion: @escaping (Result<CryptoData?, NetworkError>) -> Void) {
		if isSuccess{
			completion(Result.success(CryptoData(data: Currency(id: "1", rank: "", symbol: "", name: "Bitcoin", supply: "", maxSupply: "", marketCapUsd: "", volumeUsd24Hr: "", priceUsd: "30215.0625094995735918", changePercent24Hr: "", vwap24Hr: "", explorer: ""), timestamp: 1)))
		} else {
			var err: NetworkError!
			
			switch errorType {
			case .transportError(_):
				err = NetworkError.init(data: nil, response: HTTPURLResponse(url: URL(string:"https://api.coincap.io/v2/assets/bitcoin")!, statusCode: 500, httpVersion: nil, headerFields: nil), error: nil) ?? .noData
			case .serverError(statusCode: _):
				err = NetworkError.init(data: nil, response: nil, error: NSError()) ?? .noData
			case .noData:
				err = NetworkError.init(data: nil, response: nil, error: nil)
			case .decodingError(_):
				err = NetworkError.decodingError(NSError())
			case .encodingError(_):
				err = NetworkError.encodingError(NSError())
			}
			
			
			completion(Result.failure(err))//serverError(statusCode: 500)))
		}
	}
	
	func fetchGenericJSONData<T>(urlString: String, completion: @escaping (Result<T?, NetworkError>) -> Void) where T : Decodable {}
}
