//
//  HorizontalGridSectionView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 23/09/2024.
//

import SwiftUI

struct HorizontalGridSectionView: View {
    @State var items: [MediaItem]
    let subSection: TabSubSection
    //let rows = Array(repeating: GridItem(.fixed(60), spacing: 8, alignment: .leading), count: 4)
    @State var rows: [GridItem] = Array(repeating: GridItem(.fixed(60), spacing: 8, alignment: .leading), count: 4)
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows, spacing: 15) {
                ForEach(items) { media in
                    HStack {
                        ImageLoadView(urlString: media.artworkUrl60, size: 60, rounding: subSection.imageRounding)
                        
                        VStack(alignment: .leading) {
                            Text(media.title(forSubSection: subSection))
                                .lineLimit(2)
                            Text(media.artistName)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                        
                        Spacer()
            //            Spacer(minLength: 20)
            //
            //            BuySongButton(urlString: song.previewURL,
            //                      price: song.trackPrice,
            //                      currency: song.currency)

                    }
                    .frame(width: 250, alignment: .leading)
                }
            }
            .padding([.horizontal, .bottom])
        }
        .onAppear {
            if items.count < 4 {
                rows = Array(repeating: GridItem(.fixed(60), spacing: 8, alignment: .leading), count: 1)
            } else if items.count < 8 {
                rows = Array(repeating: GridItem(.fixed(60), spacing: 8, alignment: .leading), count: 2)
            } else {
                rows = Array(repeating: GridItem(.fixed(60), spacing: 8, alignment: .leading), count: 4)
            }
        }
    }
}

#Preview {
    HorizontalGridSectionView(items: [], subSection: .album)
}
