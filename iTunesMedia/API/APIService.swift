//
//  APIService.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 24/09/2024.
//

import Foundation

/// API For searching within the the iTunes media library for content.  Full documentation can be found at: ```https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/index.html#//apple_ref/doc/uid/TP40017632-CH3-SW1```
///
actor APIService {
    
    static let fethcBatchLimit: Int = 50
    
    func fetchMedia(searchTerm: String, entity: String, offset: Int = 0) async throws -> [MediaItem] {
        if let url = createURL(for: searchTerm, entity: entity, offset: offset) {
            do {
                let result = try await fetch(type: MediaItemResult.self, url: url)
                return result.results
            } catch {
                throw error
            }
        } else {
            throw APIError.badURL
        }
    }
    
    private func fetch<T: Decodable>(type: T.Type, url: URL?) async throws -> T {
        guard let url = url else { throw APIError.badURL }
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {throw APIError.badURL}
        guard statusCode == 200 else { throw APIError.badResponse(statusCode) }
        
        return try decodeResults(type: type, data: data)
    }
    
    func decodeResults<T: Decodable>(type: T.Type, data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw APIError.decoding(error as? DecodingError)
        }
    }
    
    func createURL(for searchTerm: String, entity: String, offset: Int = 0) -> URL? {
        guard searchTerm.isEmpty == false else { return nil }
        var queryItems = [URLQueryItem(name: "term", value: searchTerm)]
        queryItems.append(URLQueryItem(name: "entity", value: entity))
        queryItems.append(URLQueryItem(name: "country", value: "GB"))
        queryItems.append(URLQueryItem(name: "limit", value: String(APIService.fethcBatchLimit)))
        queryItems.append(URLQueryItem(name: "offset", value: String(offset)))
        var components = URLComponents(string: APIEndpoints.search.baseURL)
        components?.queryItems = queryItems
        return components?.url
    }
}
