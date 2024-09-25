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
    var lastSearchText: String = "Loyds"
    var isSearching = false
    var selectedTab: TabMainSection = .all
    var results: [TabSubSection:[MediaItem]] = [:]
    let service = APIService()
    var settings = UserStorage.shared
    
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
        search(term: searchText)
    }
    
    func searchLast() {
        search(term: settings.lastSearchTerm)
    }
    
    private func search(term: String) {
        lastSearchText = term + "... "
        isSearching = true
        results = [:]
        Task {
            await withTaskGroup(of: Bool.self) { taskGroup in
                for subSection in TabSubSection.allApiEntities {
                    taskGroup.addTask {
                        await self.search(term: term, subSection: subSection)
                    }
                }
            }
            lastSearchText = term
            settings.lastSearchTerm = term
            isSearching = false
        }
    }
    
    private func search(term: String, subSection: TabSubSection) async -> Bool {
        do {
            let items = try await service.fetchMedia(searchTerm: term, entity: subSection.apiEntityName ?? "", page: nil, limit: nil)
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
