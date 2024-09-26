//
//  LoadMoreView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 26/09/2024.
//

import SwiftUI

struct LoadMoreView: View {
    let state: QueryState
    let loadMore: () -> Void
    let searchTerm: String
    
    var body: some View {
        switch state {
            case .good:
                Color.clear
                    .onAppear {
                        loadMore()
                    }
            case .isLoading:
                HStack {
                    ProgressView() {
                        Text("Fetching more results...")
                    }
                    .frame(maxWidth: .infinity)
                    .id(UUID())
                }
            case .loadedAll:
                HStack {
                    Text("No more results found for '\(searchTerm)'")
                        .foregroundStyle(.secondary)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
            case .noResults:
                HStack {
                    Text("No Results for \(searchTerm)")
                        .foregroundStyle(.secondary)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
            case .error(let message):
            HStack {
                Text(message)
                    .foregroundColor(.red)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    LoadMoreView(state: .good, loadMore: {}, searchTerm: "Search")
}
