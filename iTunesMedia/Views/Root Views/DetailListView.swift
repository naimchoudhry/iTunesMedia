//
//  DetailListView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 23/09/2024.
//

import SwiftUI

struct DetailListView: View {
    let subSection: TabSubSection
    @Bindable var viewModel: TabRootViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.itemsFor(subSection: subSection)) { media in
                HStack(alignment: .top) {
                    ImageLoadView(urlString: media.artworkUrl100, size: 100, rounding: subSection.imageRounding)
                    
                    VStack(alignment: .leading) {
                        Text(media.title(forSubSection: subSection))
                            .font(.headline)
                            .lineLimit(2)
                        Text(media.artistName)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    DetailListView(subSection: .album, viewModel: TabRootViewModel())
}
