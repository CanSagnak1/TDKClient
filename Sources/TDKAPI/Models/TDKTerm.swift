//
//  TDKTerm.swift
//  TDKAPI
//
//  Created by Celal Can Sağnak on 6.01.2026.
//

import Foundation

public struct TDKTerm: Codable {
    public let id: String?
    public let kelime: String?  // Some endpoints use 'madde', others 'kelime', 'soz' etc. Need to check if a unified model is possible or if we need separate.
    public let anlam: String?

    // Based on `head -c` output analysis, some endpoints return slightly different keys.
    // However, the requested 'spm paketi' implies we should try to support the known schemas.
    // For "Derleme", "Bilim ve Sanat", "Batı Kökenli", the keys differ.
    // Let's create specific structs for each if they differ significantly, or use a flexible one.

    // For simplicity and based on commonly available TDK unofficial docs:
    // Derleme: madde, anlam, ...
    // Terim: id, soz, anlam, ...

    // We will define these separately to be safe.
}

public struct TDKCompilationResult: Codable {
    public let maddeId: String?
    public let madde: String?
    public let anlam: String?
    public let sehir: String?

    enum CodingKeys: String, CodingKey {
        case maddeId = "madde_id"
        case madde
        case anlam
        case sehir
    }
}

public struct TDKTermResult: Codable {
    public let id: String?
    public let soz: String?
    public let anlam: String?
    // "bilim_dali":"Biyoloji","turu":"isim"
    public let bilimDali: String?
    public let turu: String?

    enum CodingKeys: String, CodingKey {
        case id
        case soz
        case anlam
        case bilimDali = "bilim_dali"
        case turu
    }
}
