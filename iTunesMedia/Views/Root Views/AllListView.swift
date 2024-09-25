//
//  AllListView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 21/09/2024.
//

import SwiftUI

struct AllListView: View {
    
    let section: TabMainSection
    @Bindable var viewModel: TabRootViewModel
    @State var title: String = ""
    @State var searchText: String = ""
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(section.subSectionItems) { subSection in
                        if let items = viewModel.results[subSection], items.count > 0 {
                            SectionHeaderView(title: subSection.title, action: {})
                            if subSection.subSectionLayoutStyle == .grouped {
                                HorizontalGridSectionView(items: viewModel.results[subSection] ?? [], subSection: subSection)
                            } else {
                                HorizontalSectionView(items: viewModel.results[subSection] ?? [], subSection: subSection)
                            }
                        }
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    AllListView(section: .audio(.album), viewModel: TabRootViewModel())
}
