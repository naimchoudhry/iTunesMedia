//
//  DetailView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 23/09/2024.
//

import SwiftUI

struct DetailView: View {
    let section: TabMainSection
    @State var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(section.subTitle).font(.largeTitle).bold()
                SearchBarView(text: $searchText)
                DetailListView(subSection: section.subSection)
            }
        }
    }
}

#Preview {
    DetailView(section: .audio(.album))
}
