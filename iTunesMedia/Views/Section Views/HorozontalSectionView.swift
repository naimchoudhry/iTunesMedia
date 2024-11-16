//
//  HorizontalSectionView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 23/09/2024.
//

import SwiftUI

struct HorizontalSectionView: View {
    @Environment(TabRootViewModel.self) private var viewModel
    
    let subSection: TabSubSection
    let router: Router
    let displayLimit = 50
    
    @State private var position = ScrollPosition(edge: .leading)
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(alignment: .top) {
                ForEach(viewModel.itemsFor(subSection: subSection).prefix(displayLimit)) { media in
                    VStack(alignment: .leading) {
                        ImageLoadView(urlString: media.artworkUrl100, size: 100, rounding: subSection.imageRounding)
                        Text(media.title(forSubSection: subSection))
                        Text(media.artistName)
                            .foregroundColor(Color.gray)
                    }
                    .id(media.id)
                    .lineLimit(2)
                    .frame(width: 100)
                    .font(.caption)
                    .onTapGesture {
                        router.routeTo(.push) { router in
                            MediaItemView(media: media, subSection: subSection, router: router)
                                .navigationTitle(media.title(forSubSection: subSection))
                        }
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
            }
            .padding([.horizontal, .bottom])
        }
        .scrollPosition($position)
        .onChange(of: viewModel.resetScrollViews) {
            position.scrollTo(edge: .leading)
        }
    }
}

#Preview {
    HorizontalSectionView(subSection: .album, router: Router())
        .environment(TabRootViewModel())
}
