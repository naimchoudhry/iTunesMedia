//
//  TabSubSections.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 23/09/2024.
//

import Foundation

/// Tab Sub-Section Items
enum TabSubSection: Equatable, Identifiable, Hashable, CaseIterable {
    case all
    case allAudio
    case album
    case song
    case podcast
    case allVideo
    case tvshow
    case tvEpisode
    case movie
    case shortfilm
    case allApp
    case iPhoneApp
    case iPadApp
    case macApp
    case ebook
    
    var title: String {
        switch self {
        case .all: "All"
        case .allAudio: "All Audio"
        case .album: "Albums"
        case .song: "Songs"
        case .podcast: "Podcasts"
        case .allVideo: "All Video"
        case .tvshow: "TV Shows"
        case .tvEpisode: "TV Episodes"
        case .movie: "Movies"
        case .shortfilm: "Short Films"
        case .allApp: "All Apps"
        case .iPhoneApp: "iPhone Apps"
        case .iPadApp:"iPad Apps"
        case .macApp: "Mac Apps"
        case .ebook: "E-Books"
        }
    }
    
    var image: String {
        switch self {
        case .all: "list.bullet.rectangle"
        case .allAudio: "music.note.house"
        case .album: "music.note.list"
        case .song: "music.note"
        case .podcast: "airplayaudio"
        case .allVideo: "tv"
        case .tvshow: "sparkles.tv"
        case .tvEpisode : "play.tv"
        case .movie: "film"
        case .shortfilm: "video"
        case .allApp: "apps.ipad"
        case .iPhoneApp: "apps.iphone"
        case .iPadApp:"apps.ipad.landscape"
        case .macApp: "desktopcomputer"
        case .ebook: "books.vertical"
        }
    }
    
    var apiEntityName: String? {
        switch self {
        case .all: nil
        case .allAudio: nil
        case .album: "album"
        case .song: "song"
        case .podcast: "podcast"
        case .allVideo: nil
        case .tvshow: "tvSeason"
        case .tvEpisode: "tvEpisode"
        case .movie: "movie"
        case .shortfilm: "shortFilm"
        case .allApp: nil
        case .iPhoneApp: "software"
        case .iPadApp:"iPadSoftware"
        case .macApp: "macSoftware"
        case .ebook: "ebook"
        }
    }
    
    static var allApiEntities: [TabSubSection] {
        return TabSubSection.allCases.filter {$0.apiEntityName != nil}
    }
    
    var isAll: Bool {
        switch self {
        case .allAudio, .allVideo, .allApp: return true
        default: return false
        }
    }
    
    var subSectionLayoutStyle: SubSectionLayoutStyle {
        switch self {
        case .song, .iPhoneApp, .tvshow, .shortfilm, .tvEpisode: return .grouped
        default: return .plain
        }
    }
    
    var imageRounding: CGFloat? {
        switch self {
        case .song, .iPhoneApp, .shortfilm, .tvEpisode: 8
        case .podcast: 12
        case .iPadApp, .macApp: 16
        default: nil
        }
    }
            
    var id: Self {
        return self
    }
}

enum SubSectionLayoutStyle {
    case plain
    case grouped
}
