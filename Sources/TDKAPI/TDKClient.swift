//
//  TDKClient.swift
//  TDKAPI
//
//  Created by Celal Can Sağnak on 6.01.2026.
//

import Foundation

public class TDKClient {
    public static let shared = TDKClient()

    private let baseURL = "https://sozluk.gov.tr"

    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Core Search Methods

    /// Fetches results from Güncel Türkçe Sözlük (GTS)
    public func fetchGTS(word: String) async throws -> [TDKGTSResult]? {
        let url = try makeURL(
            path: "/gts",
            queryItems: [
                URLQueryItem(name: "ara", value: word.lowercased(with: Locale(identifier: "tr")))
            ])
        return try await fetch(url: url)
    }

    /// Fetches results from Atasözleri ve Deyimler Sözlüğü
    public func fetchProverbs(word: String) async throws -> [TDKProverb]? {
        let url = try makeURL(
            path: "/atasozu",
            queryItems: [
                URLQueryItem(name: "ara", value: word.lowercased(with: Locale(identifier: "tr")))
            ])
        return try await fetch(url: url)
    }

    /// Fetches results from Derleme Sözlüğü
    public func fetchCompilation(word: String) async throws -> [TDKCompilationResult]? {
        let url = try makeURL(
            path: "/derleme",
            queryItems: [
                URLQueryItem(name: "ara", value: word.lowercased(with: Locale(identifier: "tr")))
            ])
        return try await fetch(url: url)
    }

    /// Fetches results from Bilim ve Sanat Terimleri Sözlüğü
    /// Note: 'eser_ad' parameter is set to 'tümü' as per reference implementation
    public func fetchTerms(word: String) async throws -> [TDKTermResult]? {
        let url = try makeURL(
            path: "/terim",
            queryItems: [
                URLQueryItem(name: "eser_ad", value: "tümü"),
                URLQueryItem(name: "ara", value: word.lowercased(with: Locale(identifier: "tr"))),
            ])
        return try await fetch(url: url)
    }

    /// Fetches results from Türkçede Batı Kökenli Kelimeler Sözlüğü
    public func fetchWestOpposite(word: String) async throws -> [TDKWestResult]? {
        let url = try makeURL(
            path: "/bati",
            queryItems: [
                URLQueryItem(name: "ara", value: word.lowercased(with: Locale(identifier: "tr")))
            ])
        return try await fetch(url: url)
    }

    /// Fetches results from Yabancı Sözlere Karşılıklar Kılavuzu
    /// Note: 'prm' parameter is set to 'ysk' as per reference implementation
    public func fetchGuide(word: String) async throws -> [TDKForeignEquivalentResult]? {
        let url = try makeURL(
            path: "/kilavuz",
            queryItems: [
                URLQueryItem(name: "prm", value: "ysk"),
                URLQueryItem(name: "ara", value: word.lowercased(with: Locale(identifier: "tr"))),
            ])
        return try await fetch(url: url)
    }

    /// Fetches results from Eren Türk Dilinin Etimolojik Sözlüğü
    public func fetchEtymological(word: String) async throws -> [TDKEtymologicalResult]? {
        let url = try makeURL(
            path: "/etms",
            queryItems: [
                URLQueryItem(name: "ara", value: word.lowercased(with: Locale(identifier: "tr")))
            ])
        return try await fetch(url: url)
    }

    // MARK: - Aggregated Search

    /// Performs a search across all TDK dictionaries in parallel.
    /// - Parameter word: The word to search for.
    /// - Returns: A `TDKAggregatedResult` containing data from all sources.
    public func search(word: String) async throws -> TDKAggregatedResult {
        var result = TDKAggregatedResult()

        // We use TaskGroup to run requests in parallel
        await withTaskGroup(of: Void.self) { group in

            // 1. GTS
            group.addTask {
                if let gtsResults = try? await self.fetchGTS(word: word),
                    let first = gtsResults.first
                {
                    // Extract data similar to JS implementation
                    result.word = first.madde
                    result.lisan = first.lisan
                    result.means = first.anlamlarListe
                    result.compounds = first.birlesikler?.components(separatedBy: ", ").filter {
                        !$0.isEmpty
                    }
                }
            }

            // 2. Proverbs
            group.addTask {
                result.proverbs = try? await self.fetchProverbs(word: word)
            }

            // 3. Compilation
            group.addTask {
                result.compilation = try? await self.fetchCompilation(word: word)
            }

            // 4. Terms
            group.addTask {
                result.glossaryOfScienceAndArtTerms = try? await self.fetchTerms(word: word)
            }

            // 5. West Opposite
            group.addTask {
                result.westOpposite = try? await self.fetchWestOpposite(word: word)
            }

            // 6. Guide
            group.addTask {
                result.guide = try? await self.fetchGuide(word: word)
            }

            // 7. Etymological
            group.addTask {
                result.etymological = try? await self.fetchEtymological(word: word)
            }
        }

        return result
    }

    // MARK: - Private Helpers

    private func makeURL(path: String, queryItems: [URLQueryItem]) throws -> URL {
        var components = URLComponents(string: baseURL)!
        components.path = path
        components.queryItems = queryItems

        // Ensure percent encoding is handled correctly
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        return url
    }

    private func fetch<T: Codable>(url: URL) async throws -> T? {
        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            // TDK often returns 200 even for empty results, but check status code anyway
            return nil
        }

        // The API might return "error": "Sonuç bulunamadı" or similar JSON that doesn't match T[].
        // It might be easiest to try decoding T, and if it fails, maybe return nil.
        // Or check specifically for error fields if we defined a wrapper.
        // For array results, T is typically [Something].

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            // If decoding fails, it might be because the API returned an error object like {"error": "..."} instead of an array.
            // In that case, return nil (no results).
            return nil
        }
    }
}
