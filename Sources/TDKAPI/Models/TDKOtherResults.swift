//
//  TDKOtherResults.swift
//  TDKAPI
//
//  Created by Celal Can Sağnak on 6.01.2026.
//

import Foundation

public struct TDKWestResult: Codable {
    public let id: String?
    public let kelime: String?
    public let anlam: String?
    public let koken: String?
}

public struct TDKForeignEquivalentResult: Codable {
    public let id: String?
    public let kelime: String?
    public let karsilik: String?
    public let anlami: String?
}

public struct TDKEtymologicalResult: Codable {
    // Note: Etymological dictionary often returns HTML or complex text in 'ekler' or 'kelime'
    // Checking schema via curl if needed, but for now assuming basic keys
    public let kelime: String?
    public let etimoloji: String?
}
