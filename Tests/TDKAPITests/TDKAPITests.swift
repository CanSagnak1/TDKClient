//
//  TDKAPITests.swift
//  TDKAPITests
//
//  Created by Celal Can Sağnak on 6.01.2026.
//

import XCTest

@testable import TDKAPI

final class TDKAPITests: XCTestCase {

    // GTS (Güncel Türkçe Sözlük) Test
    func testGTS_Kalem() async throws {
        let results = try await TDKClient.shared.fetchGTS(word: "kalem")
        XCTAssertNotNil(results)
        XCTAssertFalse(results!.isEmpty)
        XCTAssertEqual(results?.first?.madde, "kalem")

        let meanings = results?.first?.anlamlarListe
        XCTAssertNotNil(meanings)
        XCTAssertTrue(meanings!.count > 0)
    }

    // Proverbs Test
    func testProverbs_Ac() async throws {
        let results = try await TDKClient.shared.fetchProverbs(word: "aç")
        XCTAssertNotNil(results)
        XCTAssertFalse(results!.isEmpty)

        let first = results!.first!
        XCTAssertTrue(first.sozum?.contains("aç") ?? false)
    }

    // Aggregated Search Test
    func testAggregated_Yazilim() async throws {
        let result = try await TDKClient.shared.search(word: "yazılım")

        // GTS check
        XCTAssertEqual(result.word, "yazılım")
        XCTAssertNotNil(result.means)
        XCTAssertFalse(result.means!.isEmpty)

        // Compounds check
        XCTAssertNotNil(result.compounds)
        XCTAssertTrue(
            result.compounds!.contains("yazılım dizgesi")
                || result.compounds!.contains("yazılım paketi"))

        // Terms check (yazılım has terms)
        XCTAssertNotNil(result.glossaryOfScienceAndArtTerms)
        XCTAssertFalse(result.glossaryOfScienceAndArtTerms!.isEmpty)
    }

    func testInvalidWord() async throws {
        let results = try await TDKClient.shared.fetchGTS(word: "asdfghjklornek")
        // The API returns nil or empty array for invalid words, depending on our implementation
        XCTAssertTrue(results == nil || results!.isEmpty)
    }
}
