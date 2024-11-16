//
//  AllListView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 21/09/2024.
//

import SwiftUI

struct AllListView: View {
    @Environment(TabRootViewModel.self) private var viewModel
    
    let section: TabMainSection
    let router: Router
    
    @State private var position = ScrollPosition(edge: .top)
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(section.subSectionItems) { subSection in
                        if let items = viewModel.results[subSection], items.count > 0 {
                            SectionHeaderView(title: subSection.title, action: {
                                router.routeTo(.push) { _ in
                                    DetailListView(subSection: subSection, router: router)
                                        .navigationTitle(subSection.title)
                                        .navigationBarTitleDisplayMode(.large)
                                }
                            })
                            if subSection.subSectionLayoutStyle == .grouped {
                                HorizontalGridSectionView(subSection: subSection, router: router)
                            } else {
                                HorizontalSectionView(subSection: subSection, router: router)
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
    AllListView(section: .audio(.album), router: Router())
        .environment(TabRootViewModel())
}
