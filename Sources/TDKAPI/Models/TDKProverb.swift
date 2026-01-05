//
//  TDKProverb.swift
//  TDKAPI
//
//  Created by Celal Can Sağnak on 6.01.2026.
//

import Foundation

public struct TDKProverb: Codable {
    public let sozId: String?
    public let sozum: String?
    public let atara: String?
    public let anlami: String?
    public let anahtar: String?
    public let turu2: String?

    enum CodingKeys: String, CodingKey {
        case sozId = "soz_id"
        case sozum
        case atara
        case anlami
        case anahtar
        case turu2
    }
}
