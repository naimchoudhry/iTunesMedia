//
//  DetailListView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 23/09/2024.
//

import SwiftUI

struct DetailListView: View {
    let subSection: TabSubSection
    @Bindable var viewModel: TabRootViewModel
    @State var router: Router
    
    var body: some View {
        List {
            ForEach(viewModel.itemsFor(subSection: subSection)) { media in
                HStack {
                    ItemDetailView(media: media, subSection: subSection, router: router)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(.rect)
                        .onTapGesture {
                            router.routeTo(.push) { router in
                                MediaItemView(media: media, subSection: subSection, router: router)
                                    .navigationTitle(media.title(forSubSection: subSection))
                            }
                        }
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.tint)
                }
            }
            LoadMoreView(state: viewModel.resultsState[subSection] ?? .good,
                         loadMore: { viewModel.fetchMore(subSection: subSection) },
                         searchTerm: viewModel.lastSearchText)
            .listRowSeparator(.hidden)
            
        }
        .listStyle(.plain)
    }
}

#Preview {
    DetailListView(subSection: .album, viewModel: TabRootViewModel(), router: Router())
}
