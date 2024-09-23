//
//  AllListView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 21/09/2024.
//

import SwiftUI

struct AllListView: View {
    
    let title: String
    let subSectionItems: [TabSubSection]
    @State var searchText: String = ""
    @State var selectedSubSection: TabSubSection?
    var showSubSections: Bool {
        !subSectionItems.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(title).font(.largeTitle).bold()
                SearchBar(text: $searchText)
                if showSubSections {
                    SectionPicker(subSectionItems: subSectionItems, selectedSubSection: $selectedSubSection)
                }
                let content = 1...200
                List {
                    ForEach(content, id: \.self) { index in
                        Text("\(index)")
                    }
                }
                .listStyle(.plain)
            }
        }
        .onAppear {
            if showSubSections, selectedSubSection == nil {
                selectedSubSection = subSectionItems.first
            }
        }
    }
}

#Preview {
    AllListView(title: "All List View", subSectionItems: [.allAudio, .album, .song, .podcast])
}
