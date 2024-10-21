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
    var lastSearchText: String = "Goodnotes"
    var isSearching = false
    
    private(set) var selectedTab: TabMainSection = .all
    private(set) var results: [TabSubSection:[MediaItem]] = [:]
    private(set) var resultsState: [TabSubSection: QueryState] = [:]
    private(set) var resetScrollViews: Bool = false
    
    private let service = APIService()
    private var settings = UserStorage.shared
    private var task: Task<Void, Error>?
    
    var tabHandler: Binding<TabMainSection> {
        Binding(
            get: {self.selectedTab},
            set: {
                self.selectedTab = $0
            }
        )
    }
    
    func noResults(forTab tab: TabMainSection) -> Bool {
        if isSearching {
            return false
        } else {
            if tab == .all {
                return results.values.reduce(0) {$0 + $1.count} == 0
            } else {
                var count = 0
                for sub in tab.subSectionItems {
                    count += itemsFor(subSection: sub).count
                }
                return count == 0
            }
        }
    }
    
    func itemsFor(subSection: TabSubSection) -> [MediaItem] {
        results[subSection] ?? []
    }
    
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
        search(term: settings.lastSearchTerm)
    }
    
    func fetchMore(subSection: TabSubSection) {
        guard let offset = results[subSection]?.count else { return }
        task = Task {
            await self.search(term: lastSearchText, subSection: subSection, offset: offset)
        }
    }
    
    private func search(term: String, offset: Int = 0) {
        lastSearchText = term + "... "
        isSearching = true
        print("Searching \(term)")
        if let task {
            task.cancel()
        }
        task = Task {
            try await withThrowingTaskGroup(of: Void.self) { taskGroup in
                for subSection in TabSubSection.allApiEntities {
                    try Task.checkCancellation()
                    taskGroup.addTask {
                        await self.search(term: term, subSection: subSection, offset: offset)
                    }
                }
            }
            try Task.checkCancellation()
            lastSearchText = term
            settings.lastSearchTerm = term
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
            resultsState[subSection] = .error("Could not load \(error.localizedDescription).")
            return false
        }
    }
}
