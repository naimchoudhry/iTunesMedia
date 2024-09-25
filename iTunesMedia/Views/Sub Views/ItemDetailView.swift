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
    
    var body: some View {
        HStack(alignment: .top) {
            ImageLoadView(urlString: media.artworkUrl100, size: 100, rounding: subSection.imageRounding)
            
            VStack(alignment: .leading) {
                Text(media.title(forSubSection: subSection))
                    .font(.headline)
                    .lineLimit(2)
                Text(media.artistName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                if let url = URL(string: media.previewURL), let router {
                    PreviewButton(url: url, router: router)
                        .font(.caption)
                        .buttonStyle(.bordered)
                }
            }
        }
    }
}
//TODO: Add preview
//#Preview {
//    ItemDetailView()
//}
