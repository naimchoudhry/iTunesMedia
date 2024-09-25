//
//  HorizontalSectionView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 23/09/2024.
//

import SwiftUI

struct HorizontalSectionView: View {
    let items: [MediaItem]
    let subSection: TabSubSection
    @State var router: Router?
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(alignment: .top) {
                ForEach(items) { media in
                    VStack(alignment: .leading) {
                        ImageLoadView(urlString: media.artworkUrl100, size: 100, rounding: subSection.imageRounding)
                        Text(media.title(forSubSection: subSection))
                        Text(media.artistName)
                            .foregroundColor(Color.gray)
                    }
                    .lineLimit(2)
                    .frame(width: 100)
                    .font(.caption)
                    .onTapGesture {
                        router?.routeTo(.push) { _ in
                            MediaItemView(media: media, subSection: subSection)
                                .navigationTitle(media.title(forSubSection: subSection))
                        }
                    }
                    .contextMenu(menuItems: {
                        Button("View", action: {})
                        if let url = URL(string: media.previewURL), let router {
                            PreviewButton(url: url, router: router)
                        }
                    }, preview: {
                        NavigationView {
                            VStack {
                                HStack {
                                    ItemDetailView(media: media, subSection: subSection, router: router)
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
    }
}

#Preview {
    HorizontalSectionView(items: [], subSection: .album)
}
