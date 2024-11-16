//
//  HeaderView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 24/09/2024.
//

import SwiftUI

struct HeaderView: View {
    var isSearching: Bool
    var lastSearchText: String
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.largeTitle).bold()
            Spacer()
            if isSearching {
                ProgressView()
            } else {
                Image(systemName: "sparkle.magnifyingglass")
                    .font(.title)
            }
            Text(lastSearchText)
                .font(.largeTitle).bold()
        }
    }
}

#Preview {
    HeaderView(isSearching: true, lastSearchText: "test", title: "All")
}
