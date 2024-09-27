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
    let displayLimit = 50
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(alignment: .top) {
                ForEach(items.prefix(displayLimit)) { media in
                    VStack(alignment: .leading) {
                        ImageLoadView(urlString: media.artworkUrl100, size: 100, rounding: subSection.imageRounding)
                        Text(media.title(forSubSection: subSection))
                        Text(media.artistName)
                            .foregroundColor(Color.gray)
                    }
                    .tag(media.id)
                    .lineLimit(2)
                    .frame(width: 100)
                    .font(.caption)
                    .onTapGesture {
                        router?.routeTo(.push) { router in
                            MediaItemView(media: media, subSection: subSection, router: router)
                                .navigationTitle(media.title(forSubSection: subSection))
                        }
                    }
                }
            }
            .padding([.horizontal, .bottom])
        }
    }
}

#Preview {
    HorizontalSectionView(items: [], subSection: .album)
}
