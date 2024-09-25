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
                }
            }
            .padding([.horizontal, .bottom])
        }
    }
}

#Preview {
    HorizontalSectionView(items: [], subSection: .album)
}
