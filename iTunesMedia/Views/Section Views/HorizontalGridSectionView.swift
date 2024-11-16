//
//  HorizontalGridSectionView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 23/09/2024.
//

import SwiftUI

struct HorizontalGridSectionView: View {
    @Environment(TabRootViewModel.self) private var viewModel
    
    let subSection: TabSubSection
    var router: Router
    let displayLimit = 50
    
    @State private var rows: [GridItem] = Array(repeating: GridItem(.fixed(60), spacing: 8, alignment: .leading), count: 4)
    @State private var position = ScrollPosition(edge: .leading)
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows, spacing: 15) {
                ForEach(viewModel.itemsFor(subSection: subSection).prefix(displayLimit)) { media in
                    HStack {
                        ImageLoadView(urlString: media.artworkUrl60, size: 60, rounding: subSection.imageRounding)
                        
                        VStack(alignment: .leading) {
                            Text(media.title(forSubSection: subSection))
                                .font(.subheadline)
                                .lineLimit(2)
                            Text(media.artistName)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                        Spacer()
                        if let url = URL(string: media.previewURL) {
                            PreviewButtonView(url: url, router: router)
                                .font(.caption)
                                .buttonStyle(.bordered)
                        }
                    }
                    .id(media.id)
                    .frame(width: 300, alignment: .leading)
                    .contentShape(.rect)
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
        .onAppear {
            var count = 0
            switch viewModel.itemsFor(subSection: subSection).count {
            case ...3: count = 1
            case 4...7: count = 2
            default: count = 4
            }
            rows = Array(repeating: GridItem(.fixed(60), spacing: 8, alignment: .leading), count: count)
        }
    }
}

#Preview {
    HorizontalGridSectionView(subSection: .album, router: Router())
        .environment(TabRootViewModel())
}

