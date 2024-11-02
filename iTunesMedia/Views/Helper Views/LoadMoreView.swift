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
                .id(Int.random(in: 0...1000))
                .frame(maxWidth: .infinity)
            }
            
        case .loadedAll:
            HStack {
                Text("No more results found for '\(searchTerm)'")
                    .foregroundStyle(.secondary)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            
        case .noResults:
            VStack {
                Image(systemName: "exclamationmark.magnifyingglass")
                    .font(.largeTitle)
                Text("No results for '\(searchTerm)'")
                    .font(.title)
                    .padding(.top, 30)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .foregroundStyle(.secondary)
            
        case .error:
            VStack {
                Group {
                    Text("Loading failed!")
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 8)
                    Button("Retry", systemImage: "arrow.counterclockwise.circle.fill") {
                        loadMore()
                    }
                }
                .foregroundColor(.red)
                .font(.headline)
            }
            
        }
    }
}

#Preview {
    LoadMoreView(state: .isLoading, loadMore: {}, searchTerm: "Search")
}
