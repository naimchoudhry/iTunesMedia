//
//  MediaItem.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 23/09/2024.
//

import Foundation

struct MediaItemResult: Decodable {
    let resultCount: Int
    let results: [MediaItem]
}

struct MediaItem: Identifiable, Decodable, Hashable {
    
    let id: Int
    let artistName: String
    let collectionName: String
    let artistViewURL: String?
    let previewURL: String
    let artworkUrl60: String
    let artworkUrl100: String
    let collectionPrice: Double?
    let trackName: String
    let trackCount: Int
    let currency: String
    let primaryGenreName: String
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id = "collectionId"
        case artistName, collectionName
        case artistViewURL = "artistViewUrl"
        case previewURL = "previewUrl"
        case artworkUrl60, artworkUrl100, collectionPrice, trackName, trackCount, currency, primaryGenreName, description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID().hashValue
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.collectionName = try container.decodeIfPresent(String.self, forKey: .collectionName) ?? ""
        self.artistViewURL = try container.decodeIfPresent(String.self, forKey: .artistViewURL) ?? ""
        self.previewURL = try container.decodeIfPresent(String.self, forKey: .previewURL) ?? ""
        self.artworkUrl60 = try container.decode(String.self, forKey: .artworkUrl60)
        self.artworkUrl100 = try container.decode(String.self, forKey: .artworkUrl100)
        self.collectionPrice = try container.decodeIfPresent(Double.self, forKey: .collectionPrice)
        self.trackName = try container.decodeIfPresent(String.self, forKey: .trackName) ?? ""
        self.trackCount = try container.decodeIfPresent(Int.self, forKey: .trackCount) ?? 0
        self.currency = try container.decode(String.self, forKey: .currency)
        self.primaryGenreName = try container.decodeIfPresent(String.self, forKey: .primaryGenreName) ?? ""
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? nil
    }
    
    func title(forSubSection subSection: TabSubSection) -> String {
        switch subSection {
        case .iPhoneApp, .iPadApp, .tvEpisode, .ebook, .macApp:  trackName
        case .movie: trackName.isEmpty ? collectionName : trackName
        default:  collectionName
        }
    }
}
