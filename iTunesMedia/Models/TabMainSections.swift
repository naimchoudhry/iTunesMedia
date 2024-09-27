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
        case .book: "Books"
        case .audio: "Audio"
        case .video: "Videos"
        case .app: "Apps"
        }
    }
    
    var subTitle: String {
        switch self {
        case .all, .book: self.title
        case .audio(let subSection): subSection.title
        case .video(let subSection): subSection.title
        case .app(let subSection): subSection.title
        }
    }
    
    var image: String {
        switch self {
        case .all: "house"
        case .book: "books.vertical"
        case .audio: "music.note"
        case .video: "tv"
        case .app: "apps.ipad"
        }
    }
    
    var subImage: String {
        switch self {
        case .all, .book: self.image
        case .audio(let subSection): subSection.image
        case .video(let subSection): subSection.image
        case .app(let subSection): subSection.image
        }
    }
    
    var id: Self {
        return self
    }
    
    var subSections: [TabMainSection]? {
        switch self {
        case .audio: [.audio(.allAudio), .audio(.album), .audio(.song), .audio(.podcast)]
        case .video: [.video(.allVideo), .video(.movie), .video(.tvshow), .video(.tvEpisode)]
        case .app: [.app(.allApp), .app(.iPhoneApp), .app(.iPadApp), .app(.macApp)]
        default: nil
        }
    }
    
    var subSectionItems: [TabSubSection] {
        switch self {
        case .all: [.ebook, .album, .song, .podcast, .tvshow, .tvEpisode, .movie, .iPhoneApp, .iPadApp, .macApp]
        case .book: []
        case .audio: [.album, .song, .podcast]
        case .video: [.tvshow, .tvEpisode, .movie]
        case .app: [.iPhoneApp, .iPadApp, .macApp]
        }
    }
    
    var subSectionFilterItems: [TabSubSection] {
        switch self {
        case .all: []
        case .book: []
        case .audio(let subSection): subSection == .allAudio ? [.allAudio, .album, .song, .podcast] : []
        case .video(let subSection): subSection == .allVideo ? [.allVideo, .tvshow, .tvEpisode, .movie] : []
        case .app(let subSection): subSection == .allApp ? [.allApp, .iPhoneApp, .iPadApp, .macApp] : []
        }
    }
    
    var isAll: Bool {
        switch self {
        case .all: true
        case .book: false
        case .audio(let subSection): subSection == .allAudio ? true : false
        case .video(let subSection): subSection == .allVideo ? true : false
        case .app(let subSection): subSection == .allApp ? true : false
        }
    }
    
    var subSection: TabSubSection {
        switch self {
        case .all: .all
        case .book: .ebook
        case .audio(let subSection): subSection
        case .video(let subSection): subSection
        case .app(let subSection): subSection
        }
    }
}

