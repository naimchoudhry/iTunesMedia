//
//  ItemDetailView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 25/09/2024.
//

import SwiftUI

struct ItemDetailView: View {
    
    let media: MediaItem
    let subSection: TabSubSection
    let router: Router?
    var hidePrevieButton: Bool = false
    
    var body: some View {
        HStack(alignment: .top) {
            ImageLoadView(urlString: media.artworkUrl100, size: 100, rounding: subSection.imageRounding)
            
            VStack(alignment: .leading) {
                Text(media.title(forSubSection: subSection))
                    .font(.headline)
                    .lineLimit(3)
                Text(media.artistName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(3)
                if !hidePrevieButton, let url = URL(string: media.previewURL), let router {
                    PreviewButtonView(url: url, router: router)
                        .font(.caption)
                        .buttonStyle(.bordered)
                }
            }
        }
    }
}

