//
//  iTunesMediaTests.swift
//  iTunesMediaTests
//
//  Created by Naim Choudhry on 21/09/2024.
//

import Testing
@testable import iTunesMedia

@MainActor
struct ViewModelTests {

    let viewModel = TabRootViewModel()
    
    @Test("Check searching starts") func searchLast() async throws {
        viewModel.searchLast()
        #expect(viewModel.isSearching == true)
    }
}

