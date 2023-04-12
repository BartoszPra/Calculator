//
//  APIService.swift
//  Calculator
//
//  Created by Bartosz Prazmo on 09/04/2023.
//

import Foundation

protocol Networking {	
	func fetchBitcoinPrice(completion: @escaping (Result<CryptoData?, NetworkError>) -> Void)
}

class NetworkManager: Networking {
	
	static let shared = NetworkManager()
	
	func fetchBitcoinPrice(completion: @escaping (Result<CryptoData?, NetworkError>) -> Void) {
		let urlString = Constants.BitCoinUrlString
		fetchGenericJSONData(urlString: urlString, completion: completion)
	}

	func fetchGenericJSONData<T: Decodable>(urlString: String, completion: @escaping (Result<T?, NetworkError>) -> Void) {
		guard let url = URL(string: urlString) else { return }
		
		URLSession.shared.dataTask(with: url) { data, response, error in
			if let networkError = NetworkError(data: data, response: response, error: error) {
				completion(.failure(networkError))
			}
			do {
				let obj = try JSONDecoder().decode(T.self, from: data!)
				completion(.success(obj))
			} catch {
				completion(.failure(.decodingError(error)))
			}
		}.resume()
	}

}
