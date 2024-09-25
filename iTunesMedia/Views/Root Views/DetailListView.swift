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
                            router.routeTo(.push) { _ in
                                MediaItemView(media: media, subSection: subSection)
                                    .navigationTitle(media.title(forSubSection: subSection))
                            }
                        }
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.tint)
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    DetailListView(subSection: .album, viewModel: TabRootViewModel(), router: Router())
}
