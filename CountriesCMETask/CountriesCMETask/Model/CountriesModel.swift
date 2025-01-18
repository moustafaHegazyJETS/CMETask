//
//  CountriesModel.swift
//  CountriesCMETask
//
//  Created by Moustafa Hegazy on 17/01/2025.
//

import Foundation

// MARK: - CountryElement
struct CountryElement: Codable {
	let name: Name?
	let currencies: [String: Currency]?
	let capital: [String]?
	let ccn3: String
}

// MARK: - Currency
struct Currency: Codable {
	let name, symbol: String?
}

// MARK: - Name
struct Name: Codable {
	let common, official: String?
	let nativeName: [String: NativeName]?
}

// MARK: - NativeName
struct NativeName: Codable {
	let official, common: String?
}

extension CountryElement: Identifiable {
	var id: Int {
		Int(ccn3) ?? 0
	}
}


typealias Country = [CountryElement]
