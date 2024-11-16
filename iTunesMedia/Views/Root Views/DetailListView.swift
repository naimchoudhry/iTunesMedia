//
//  DetailListView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 23/09/2024.
//

import SwiftUI

struct DetailListView: View {
    @Environment(TabRootViewModel.self) private var viewModel
    
    let subSection: TabSubSection
    let router: Router
    
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
                .contextMenu(menuItems: {
                    Button("View", systemImage: "eye") {
                        router.routeTo(.push) { router in
                            MediaItemView(media: media, subSection: subSection, router: router)
                                .navigationTitle(media.title(forSubSection: subSection))
                        }
                    }
                    if let url = URL(string: media.previewURL) {
                        PreviewButtonView(url: url, router: router, hideImage: false)
                    }
                }, preview: {
                    NavigationView {
                        VStack {
                            HStack {
                                ItemDetailView(media: media, subSection: subSection, router: router, hidePrevieButton: true, lineLimit: false)
                                Spacer()
                            }
                            Spacer()
                        }
                        .padding()
                    }
                })
            }
            LoadMoreView(state: viewModel.resultsState[subSection] ?? .good,
                         loadMore: { viewModel.fetchMore(subSection: subSection) },
                         searchTerm: viewModel.lastSearchText)
            .listRowSeparator(.hidden)
            
        }
        .listStyle(.plain)
        .animation(.easeInOut, value: viewModel.results)
    }
}

#Preview {
    DetailListView(subSection: .album, router: Router())
        .environment(TabRootViewModel())
}
