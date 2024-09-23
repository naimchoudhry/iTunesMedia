//
//  AllListView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 21/09/2024.
//

import SwiftUI

struct AllListView: View {
    
    let section: TabMainSection
    @State var title: String = ""
    @State var searchText: String = ""
    
    var body: some View {
        VStack {
            LazyVStack {
                ForEach(section.subSectionItems) { subSection in
                    SectionHeaderView(title: subSection.title, action: {})
                }
            }
            Spacer()
        }
    }
}

#Preview {
    AllListView(section: .audio(.album))
}
