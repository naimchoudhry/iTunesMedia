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
    var router: Router
    
    @State var title: String = ""
    @State private var position = ScrollPosition(edge: .top)
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(section.subSectionItems) { subSection in
                        if let items = viewModel.results[subSection], items.count > 0 {
                            SectionHeaderView(title: subSection.title, action: {
                                router.routeTo(.push) { _ in
                                    DetailListView(subSection: subSection, viewModel: viewModel, router: router)
                                        .navigationTitle(subSection.title)
                                        .navigationBarTitleDisplayMode(.large)
                                }
                            })
                            if subSection.subSectionLayoutStyle == .grouped {
                                HorizontalGridSectionView(viewModel: viewModel, subSection: subSection, router: router)
                            } else {
                                HorizontalSectionView(viewModel: viewModel, subSection: subSection, router: router)
                            }
                        }
                    }
                }
            }
            .scrollPosition($position)
            Spacer()
        }
        .animation(.easeInOut, value: viewModel.results)
        .overlay {
            if viewModel.noResults(forTab: section) {
                ContentUnavailableView("No results for '\(viewModel.lastSearchText)'", systemImage: "exclamationmark.magnifyingglass", description: Text("Try another search"))
            }
        }
        .onChange(of: viewModel.resetScrollViews) {
            position.scrollTo(edge: .top)
        }
    }
}

#Preview {
    AllListView(section: .audio(.album), viewModel: TabRootViewModel(), router: Router())
}
