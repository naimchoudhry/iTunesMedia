//
//  APIError.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 24/09/2024.
//

import Foundation

enum APIEndpoints {
    case search
    
    var baseURL: String {
        switch self {
        case .search: "https://itunes.apple.com/search"
        }
    }
}

enum APIError: Error, CustomStringConvertible {
    
    case badURL
    case urlSession(URLError?)
    case badResponse(Int)
    case decoding(DecodingError?)
    case unknown
    
    var description: String {
        switch self {
            case .badURL: "badURL"
            case .urlSession(let error): "urlSession error: \(error.debugDescription)"
            case .badResponse(let statusCode): "bad response with status code: \(statusCode)"
            case .decoding(let decodingError): "decoding error: \(decodingError.debugDescription)"
            case .unknown: "unknown error"
        }
    }
    
    var localizedDescription: String {
        switch self {
            case .badURL, .unknown: "something went wrong"
            case .urlSession(let urlError): urlError?.localizedDescription ?? "something went wrong"
            case .badResponse(_): "something went wrong"
            case .decoding(let decodingError): decodingError?.localizedDescription ?? "something went wrong"
        }
    }
}
