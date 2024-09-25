//
//  APIService.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 24/09/2024.
//

import Foundation

class APIService {
    
    func fetchMedia(searchTerm: String, entity: String, page: Int?, limit: Int?) async throws -> [MediaItem] {
        let url = createURL(for: searchTerm, entity: entity, page: page, limit: limit)
        do {
            let result = try await fetch(type: MediaItemResult.self, url: url)
            return result.results
        } catch {
            throw error
        }
        
    }
    
    func fetch<T: Decodable>(type: T.Type, url: URL?) async throws -> T {
        guard let url = url else { throw APIError.badURL }
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.badURL }
        
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw APIError.decoding(error as? DecodingError)
        }
    }
    
    func createURL(for searchTerm: String, entity: String, page: Int?, limit: Int?) -> URL? {
        let baseURL = "https://itunes.apple.com/search"
        var queryItems = [URLQueryItem(name: "term", value: searchTerm)]
        queryItems.append(URLQueryItem(name: "entity", value: entity))
        queryItems.append(URLQueryItem(name: "country", value: "GB"))
        if let page = page, let limit = limit {
            let offset = page * limit
            queryItems.append(URLQueryItem(name: "limit", value: String(limit)))
            queryItems.append(URLQueryItem(name: "offset", value: String(offset)))
        }
        
        var components = URLComponents(string: baseURL)
        components?.queryItems = queryItems
        return components?.url
    }
}
