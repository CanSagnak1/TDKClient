//
//  TDKAggregatedResult.swift
//  TDKAPI
//
//  Created by Celal Can Sağnak on 6.01.2026.
//

import Foundation

public struct TDKAggregatedResult: Codable {
    public var word: String?
    public var lisan: String?
    public var means: [TDKMeaning]?
    public var compounds: [String]?
    public var proverbs: [TDKProverb]?
    public var compilation: [TDKCompilationResult]?
    public var glossaryOfScienceAndArtTerms: [TDKTermResult]?
    public var westOpposite: [TDKWestResult]?
    public var guide: [TDKForeignEquivalentResult]?
    public var etymological: [TDKEtymologicalResult]?

    public init(
        word: String? = nil,
        lisan: String? = nil,
        means: [TDKMeaning]? = nil,
        compounds: [String]? = nil,
        proverbs: [TDKProverb]? = nil,
        compilation: [TDKCompilationResult]? = nil,
        glossaryOfScienceAndArtTerms: [TDKTermResult]? = nil,
        westOpposite: [TDKWestResult]? = nil,
        guide: [TDKForeignEquivalentResult]? = nil,
        etymological: [TDKEtymologicalResult]? = nil
    ) {
        self.word = word
        self.lisan = lisan
        self.means = means
        self.compounds = compounds
        self.proverbs = proverbs
        self.compilation = compilation
        self.glossaryOfScienceAndArtTerms = glossaryOfScienceAndArtTerms
        self.westOpposite = westOpposite
        self.guide = guide
        self.etymological = etymological
    }
}
