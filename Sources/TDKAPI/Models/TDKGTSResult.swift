//
//  TDKGTSResult.swift
//  TDKAPI
//
//  Created by Celal Can Sağnak on 6.01.2026.
//

import Foundation

public struct TDKGTSResult: Codable {
    public let maddeId: String?
    public let kac: String?
    public let kelimeNo: String?
    public let cesit: String?
    public let anlamGor: String?
    public let onTaki: String?
    public let madde: String?
    public let cesitSay: String?
    public let anlamSay: String?
    public let taki: String?
    public let cogulMu: String?
    public let ozelMi: String?
    public let egikMi: String?
    public let lisanKodu: String?
    public let lisan: String?
    public let telaffuz: String?
    public let birlesikler: String?
    public let maddeDuz: String?
    public let anlamlarListe: [TDKMeaning]?

    enum CodingKeys: String, CodingKey {
        case maddeId = "madde_id"
        case kac
        case kelimeNo = "kelime_no"
        case cesit
        case anlamGor = "anlam_gor"
        case onTaki = "on_taki"
        case madde
        case cesitSay = "cesit_say"
        case anlamSay = "anlam_say"
        case taki
        case cogulMu = "cogul_mu"
        case ozelMi = "ozel_mi"
        case egikMi = "egik_mi"
        case lisanKodu = "lisan_kodu"
        case lisan
        case telaffuz
        case birlesikler
        case maddeDuz = "madde_duz"
        case anlamlarListe
    }
}

public struct TDKMeaning: Codable {
    public let anlamId: String?
    public let maddeId: String?
    public let anlamSira: String?
    public let fiil: String?
    public let tipkes: String?
    public let anlam: String?
    public let gos: String?
    public let orneklerListe: [TDKExample]?
    public let ozelliklerListe: [TDKProperty]?

    enum CodingKeys: String, CodingKey {
        case anlamId = "anlam_id"
        case maddeId = "madde_id"
        case anlamSira = "anlam_sira"
        case fiil
        case tipkes
        case anlam
        case gos
        case orneklerListe
        case ozelliklerListe
    }
}

public struct TDKExample: Codable {
    public let ornekId: String?
    public let anlamId: String?
    public let ornekSira: String?
    public let ornek: String?
    public let kac: String?
    public let yazarId: String?
    public let yazar: [TDKAuthor]?

    enum CodingKeys: String, CodingKey {
        case ornekId = "ornek_id"
        case anlamId = "anlam_id"
        case ornekSira = "ornek_sira"
        case ornek
        case kac
        case yazarId = "yazar_id"
        case yazar
    }
}

public struct TDKAuthor: Codable {
    public let yazarId: String?
    public let tamAdi: String?
    public let kisaAdi: String?
    public let ekno: String?

    enum CodingKeys: String, CodingKey {
        case yazarId = "yazar_id"
        case tamAdi = "tam_adi"
        case kisaAdi = "kisa_adi"
        case ekno
    }
}

public struct TDKProperty: Codable {
    public let ozellikId: String?
    public let tur: String?
    public let tamAdi: String?
    public let kisaAdi: String?
    public let ekno: String?

    enum CodingKeys: String, CodingKey {
        case ozellikId = "ozellik_id"
        case tur
        case tamAdi = "tam_adi"
        case kisaAdi = "kisa_adi"
        case ekno
    }
}
