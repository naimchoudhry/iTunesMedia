//
//  TabRootViewModel.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 21/09/2024.
//

import SwiftUI

@MainActor
@Observable
class TabRootViewModel {
    var searchText: String = ""
    var lastSearchText: String = ""
    var isSearching = false
    var selectedTab: TabMainSection = .all
    var results: [TabSubSection:[MediaItem]] = [:]
    let service = APIService()
    
    init() {
        print("TabRootViewModel - INIT")
    }
    
    deinit {
        print("TabRootViewModel - DEINIT")
    }
    
    var tabHandler: Binding<TabMainSection> {
        Binding(
            get: {self.selectedTab},
            set: {
                self.selectedTab = $0
            }
        )
    }
    
    func itemsFor(subSection: TabSubSection) -> [MediaItem] {
        results[subSection] ?? []
    }
    
    func search() {
        guard searchText.isEmpty == false else { return }
        lastSearchText = searchText + "... "
        isSearching = true
        results = [:]
        Task {
            await withTaskGroup(of: Bool.self) { taskGroup in
                for subSection in TabSubSection.allApiEntities {
                    taskGroup.addTask {
                        await self.search(subSection: subSection)
                    }
                }
            }
            lastSearchText = searchText
            isSearching = false
        }
    }
    
    func search(subSection: TabSubSection) async -> Bool {
        do {
            let items = try await service.fetchMedia(searchTerm: searchText, entity: subSection.apiEntityName ?? "", page: nil, limit: nil)
            results[subSection] = items
            print(subSection.title, items.count)
            return true
        } catch {
            print("Error for \(subSection.apiEntityName ?? "nil"): \(error)")
            results[subSection] = []
            return false
        }
    }
    
}
