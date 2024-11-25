//
//  MediaItemView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 25/09/2024...
//

import SwiftUI

struct MediaItemView: View {
    let media: MediaItem
    let subSection: TabSubSection
    let router: Router
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                ImageLoadView(urlString: media.artworkUrl100, size: 100, rounding: subSection.imageRounding)
                
                VStack(alignment: .leading) {
                    Text(media.title(forSubSection: subSection))
                        .font(.title)
                    Text(media.artistName)
                        .font(.title)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            if let url = URL(string: media.previewURL) {
                PreviewButtonView(url: url, router: router)
                    .font(.headline)
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom)
            }
            
            Divider()
            if let description = media.description {
                ScrollView(.vertical) {
                    Text(description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil))
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    MediaItemView(media: .preview, subSection: .iPhoneApp, router: Router())
}
