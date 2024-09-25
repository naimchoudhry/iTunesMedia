//
//  MediaItemView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 25/09/2024.
//

import SwiftUI

struct MediaItemView: View {
    let media: MediaItem
    let subSection: TabSubSection
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                ImageLoadView(urlString: media.artworkUrl100, size: 100, rounding: subSection.imageRounding)
                
                VStack(alignment: .leading) {
                    Text(media.title(forSubSection: subSection))
                        .font(.title)
                        .lineLimit(3)
                    Text(media.artistName)
                        .font(.title)
                        .foregroundColor(.gray)
                        .lineLimit(3)
                }
                Spacer()
            }
            Divider()
            if let description = media.description {
                ScrollView(.vertical) {
                    Text(description)
                }
                
            }
            Spacer()
        }
        .padding()
    }
}

//#Preview {
//    MediaItemView()
//}
