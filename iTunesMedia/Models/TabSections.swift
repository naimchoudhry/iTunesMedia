//
//  TabSections.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 21/09/2024.
//

import Foundation

/// Main Tab Section Views
enum TabMainSection: Equatable, Identifiable, Hashable {
    case all
    case audio(TabSubSection)
    case video(TabSubSection)
    case app(TabSubSection)
    case book
    
    static var mainSections: [TabMainSection] =  [.all, .book, .audio(.allAudio), .video(.allVideo), .app(.allApp)]
    
    var title: String {
        switch self {
        case .all: "All"
        case .audio: "Audio"
        case .video: "Videos"
        case .app: "Apps"
        case .book: "Books"
        }
    }
    
    var subTitle: String {
        switch self {
        case .all: ""
        case .audio(let subSection): subSection.title
        case .video(let subSection): subSection.title
        case .app(let subSection): subSection.title
        case .book: ""
        }
    }
    
    var image: String {
        switch self {
        case .all: "house"
        case .audio: "music.note"
        case .video: "tv"
        case .app: "apps.ipad"
        case .book: "books.vertical"
        }
    }
    
    var subImage: String {
        switch self {
        case .all: ""
        case .audio(let subSection): subSection.image
        case .video(let subSection): subSection.image
        case .app(let subSection): subSection.image
        case .book: ""
        }
    }
    
    var id: Self {
        return self
    }
    
    var subSections: [TabMainSection]? {
        switch self {
        case .audio: [.audio(.allAudio), .audio(.album), .audio(.song), .audio(.podcast)]
        case .video: [.video(.allVideo), .video(.movie), .video(.tvshow), .video(.shortfilm)]
        case .app: [.app(.allApp), .app(.iPhoneApp), .app(.iPadApp), .app(.macApp)]
        default: nil
        }
    }
    
    var subSectionItems: [TabSubSection] {
        switch self {
        case .all: []
        case .audio(let subSection): subSection == .allAudio ? [.allAudio, .album, .song, .podcast] : []
        case .video(let subSection): subSection == .allVideo ? [.allVideo, .tvshow, .movie, .shortfilm] : []
        case .app(let subSection): subSection == .allApp ? [.allApp, .iPhoneApp, .iPadApp, .macApp] : []
        case .book: []
        }
    }
}

/// Tab Sub-Section Items
enum TabSubSection: Equatable, Identifiable, Hashable {
    case allAudio
    case album
    case song
    case podcast
    case allVideo
    case tvshow
    case movie
    case shortfilm
    case allApp
    case iPhoneApp
    case iPadApp
    case macApp
    case ebook
    
    var title: String {
        switch self {
        case .allAudio: "All Audio"
        case .album: "Albums"
        case .song: "Songs"
        case .podcast: "Podcasts"
        case .allVideo: "All Video"
        case .tvshow: "TV Shows"
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
        case .allAudio: "music.note.house"
        case .album: "music.note.list"
        case .song: "music.note"
        case .podcast: "airplayaudio"
        case .allVideo: "tv"
        case .tvshow: "play.tv"
        case .movie: "film"
        case .shortfilm: "video"
        case .allApp: "apps.ipad"
        case .iPhoneApp: "apps.iphone"
        case .iPadApp:"apps.ipad.landscape"
        case .macApp: "desktopcomputer"
        case .ebook: "books.vertical"
        }
    }
            
    var id: Self {
        return self
    }
}
