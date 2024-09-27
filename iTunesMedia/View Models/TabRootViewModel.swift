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
    var resultsState: [TabSubSection: QueryState] = [:]
    private let service = APIService()
    private var settings = UserStorage.shared
    
    var tabHandler: Binding<TabMainSection> {
        Binding(
            get: {self.selectedTab},
            set: {
                self.selectedTab = $0
            }
        )
    }
    
    var noResults: Bool {
        if isSearching {
            return false
        } else {
            return results.values.reduce(0) {$0 + $1.count} == 0
        }
    }
    
    func itemsFor(subSection: TabSubSection) -> [MediaItem] {
        results[subSection] ?? []
    }
    
    func search() {
        guard searchText.isEmpty == false else { return }
        results = [:]
        resultsState = [:]
        search(term: searchText)
    }
    
    func searchLast() {
        results = [:]
        resultsState = [:]
        search(term: settings.lastSearchTerm)
    }
    
    func fetchMore(subSection: TabSubSection) {
        guard let offset = results[subSection]?.count else { return }
        Task {
            await self.search(term: lastSearchText, subSection: subSection, offset: offset)
        }
    }
    
    private func search(term: String, offset: Int = 0) {
        lastSearchText = term + "... "
        isSearching = true
        
        Task {
            await withTaskGroup(of: Bool.self) { taskGroup in
                for subSection in TabSubSection.allApiEntities {
                    taskGroup.addTask {
                        await self.search(term: term, subSection: subSection, offset: offset)
                    }
                }
            }
            lastSearchText = term
            settings.lastSearchTerm = term
            isSearching = false
        }
    }
    
    private func search(term: String, subSection: TabSubSection, offset: Int = 0) async -> Bool {
        do {
            resultsState[subSection] = .isLoading
            let items = try await service.fetchMedia(searchTerm: term, entity: subSection.apiEntityName ?? "", offset: offset)
            results[subSection] = (results[subSection] ?? []) + items
            if results[subSection]?.count == 0 {
                resultsState[subSection] = .noResults
            } else {
                resultsState[subSection] = items.count < APIService.fethcBatchLimit ? .loadedAll : .good
            }
            return true
        } catch {
            print("Error for \(subSection.apiEntityName ?? "nil"): \(error)")
            resultsState[subSection] = .error("Could not load \(error.localizedDescription).")
            return false
        }
    }
    
}
