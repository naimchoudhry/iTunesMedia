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
    @State var router: Router
    
    @State var title: String = ""
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(section.subSectionItems) { subSection in
                        if let items = viewModel.results[subSection], items.count > 0 {
                            SectionHeaderView(title: subSection.title, action: {
                                router = router.routeTo(.push) { _ in
                                    DetailListView(subSection: subSection, viewModel: viewModel, router: router)
                                        .navigationTitle(subSection.title)
                                        .navigationBarTitleDisplayMode(.large)
                                }
                            })
                            if subSection.subSectionLayoutStyle == .grouped {
                                HorizontalGridSectionView(items: viewModel.itemsFor(subSection: subSection), subSection: subSection, router: router)
                            } else {
                                HorizontalSectionView(items: viewModel.itemsFor(subSection: subSection), subSection: subSection, router: router)
                            }
                        }
                    }
                }

            }
            Spacer()
        }
        .overlay {
            if viewModel.noResults {
                ContentUnavailableView("No results for '\(viewModel.lastSearchText)'", systemImage: "exclamationmark.magnifyingglass", description: Text("Try another search"))
            }
        }
    }
}

#Preview {
    AllListView(section: .audio(.album), viewModel: TabRootViewModel(), router: Router())
}
