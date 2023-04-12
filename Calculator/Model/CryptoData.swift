//
//  CryptoData.swift
//  Calculator
//
//  Created by Bartosz Prazmo on 09/04/2023.
//

import Foundation

// MARK: - CryptoData
struct CryptoData: Codable {
	let data: Currency
	let timestamp: Int
}

// MARK: - DataClass
struct Currency: Codable {
	let id, rank, symbol, name: String
	let supply, maxSupply, marketCapUsd, volumeUsd24Hr: String
	let priceUsd, changePercent24Hr, vwap24Hr: String
	let explorer: String
}
