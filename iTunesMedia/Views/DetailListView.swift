//
//  DetailListView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 23/09/2024.
//

import SwiftUI

struct DetailListView: View {
    let subSection: TabSubSection
    var body: some View {
        List {
            let content = 1...200
            ForEach(content, id: \.self) { index in
                Text("Details for \(index)")
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    DetailListView(subSection: .album)
}
