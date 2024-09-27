//
//  SectionPicker.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 22/09/2024.
//

import SwiftUI

struct SectionPickerView: View {
    
    let subSectionItems: [TabSubSection]
    @Binding var selectedSubSection: TabSubSection?
    
    var body: some View {
        Picker("Select the media", selection: $selectedSubSection) {
            ForEach(subSectionItems) { subSection in
                Text(subSection.title)
                    .tag(subSection)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
}

#Preview {
    SectionPickerView(subSectionItems: [.allAudio, .album, .song, .podcast], selectedSubSection: .constant(.song))
}
