//
//  TabRootViewModel.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 21/09/2024.
//

import SwiftUI

@MainActor @Observable final class TabRootViewModel {
    var searchText: String = ""
    var isSearching = false
    
    private(set) var lastSearchText: String = UserStorage.shared.lastSearchTerm
    private(set) var results: [TabSubSection:[MediaItem]] = [:]
    private(set) var resultsState: [TabSubSection: QueryState] = [:]
    private(set) var resetScrollViews: Bool = false
    
    private let service = APIService()
    private var task: Task<Void, Error>?
    
    // Search Functions
    
    func search() {
        guard searchText.isEmpty == false else { return }
        guard searchText != lastSearchText else { return }
        Task {
            await ImageDownloader.shared.purgeCache()
        }
        results = [:]
        resultsState = [:]
        resetScrollViews.toggle()
        
        search(term: searchText)
    }
    
    func searchLast() {
        results = [:]
        resultsState = [:]
        search(term: UserStorage.shared.lastSearchTerm)
    }
    
    func fetchMore(subSection: TabSubSection) {
        let offset = results[subSection]?.count ?? 0
        task = Task {
            await self.search(term: lastSearchText, subSection: subSection, offset: offset)
        }
    }
    
    // Helper Functions
    
    func itemsFor(subSection: TabSubSection) -> [MediaItem] {
        results[subSection] ?? []
    }
    
    func noResults(forTab tab: TabMainSection) -> Bool {
        guard !isSearching else { return false }
        if tab == .all {
            return results.values.reduce(0) {$0 + $1.count} == 0
        } else {
            return tab.subSectionItems.reduce(0) {$0 + itemsFor(subSection: $1).count} == 0
        }
    }
}

/// Private Search Functions
extension TabRootViewModel {
    private func search(term: String) {
        lastSearchText = term + "... "
        isSearching = true
        if let task {
            task.cancel()
        }
        task = Task {
            try await withThrowingTaskGroup(of: Void.self) { taskGroup in
                for subSection in TabSubSection.allApiEntities {
                    try Task.checkCancellation()
                    taskGroup.addTask {
                        await self.search(term: term, subSection: subSection, offset: 0)
                    }
                }
            }
            try Task.checkCancellation()
            lastSearchText = term
            UserStorage.shared.lastSearchTerm = term
            isSearching = false
            self.task = nil
        }
    }
    
    @discardableResult private func search(term: String, subSection: TabSubSection, offset: Int = 0) async -> Bool {
        do {
            resultsState[subSection] = .isLoading
            let items = try await service.fetchMedia(searchTerm: term, entity: subSection.apiEntityName ?? "", offset: offset)
            if offset == 0 {
                results[subSection] = items
            } else {
                results[subSection] = (results[subSection] ?? []) + items
            }
            if results[subSection]?.count == 0 {
                resultsState[subSection] = .noResults
            } else {
                resultsState[subSection] = items.count < APIService.fethcBatchLimit ? .loadedAll : .good
            }
            return true
        } catch {
            if offset == 0 {
                results[subSection] = []
            }
            print("Error for \(subSection.apiEntityName ?? "nil"): \(error)")
            resultsState[subSection] = .error("Could not load error: \(error.localizedDescription).")
            return false
        }
    }
}
