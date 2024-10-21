//
//  APITests.swift
//  iTunesMediaTests
//
//  Created by Naim Choudhry on 26/09/2024.
//

import Testing
@testable import iTunesMedia

struct APITests {
    
    let service = APIService()
    
    @Test("Test URL Creation for empty word search")
    func testUrlEmpty() async throws {
        let apiEntityName = try #require(TabSubSection.album.apiEntityName)
        await #expect(service.createURL(for: "", entity: apiEntityName) == nil)
    }
    
    @Test("Test URL Creation for one word search")
    func testUrlOne() async throws {
        let apiEntityName = try #require(TabSubSection.album.apiEntityName)
        let url = try #require(await service.createURL(for: "One", entity: apiEntityName))
        #expect(url.description == "https://itunes.apple.com/search?term=One&entity=album&country=GB&limit=50&offset=0")
    }
    
    @Test("Test URL Creation for two word search")
    func testUrlTwo() async throws {
        let apiEntityName = try #require(TabSubSection.album.apiEntityName)
        let url = try #require(await service.createURL(for: "One Two", entity: apiEntityName))
        #expect(url.description == "https://itunes.apple.com/search?term=One%20Two&entity=album&country=GB&limit=50&offset=0")
    }
    
    @Test("Test URL Creation for two word search with offset")
    func testUrlTwoOffset() async throws {
        let apiEntityName = try #require(TabSubSection.album.apiEntityName)
        let url = try #require(await service.createURL(for: "One Two", entity: apiEntityName, offset: 123))
        #expect(url.description == "https://itunes.apple.com/search?term=One%20Two&entity=album&country=GB&limit=50&offset=123")
    }
    
    // Assumption through testings is that 'Jackson' returns media items in all categories
    @Test("Check search on 'Jackson' for all media types",
          arguments: [TabSubSection.album, .song, .podcast, .tvshow, .tvEpisode, .movie, .iPhoneApp, .iPadApp, .macApp, .ebook]
    )
    func searchOnJackson(_ subSection: TabSubSection) async throws {
        let apiEntityName = try #require(subSection.apiEntityName)
        let results = try await service.fetchMedia(searchTerm: "Jackson", entity: apiEntityName)
        #expect(results.count > 0)
    }
    
}
