//
//  AllView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 23/09/2024.
//

import SwiftUI

struct AllView: View {
    let section: TabMainSection
    let subSectionFilterItems: [TabSubSection]
    @Bindable var viewModel: TabRootViewModel
    @State private var title: String = ""
    @State private var selectedSubSection: TabSubSection?
    private var showSubSections: Bool {
        !subSectionFilterItems.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(title)
                        .font(.largeTitle).bold()
                    Spacer()
                    if viewModel.isSearching {
                        ProgressView()
                    } else {
                        Image(systemName: "sparkle.magnifyingglass")
                            .font(.title)
                    }
                    Text(viewModel.lastSearchText)
                        .font(.largeTitle).bold()
                }
                
                .padding(.horizontal)
                
                SearchBarView(text: $viewModel.searchText)
                    .onSubmit {
                        viewModel.search()
                    }
                if showSubSections {
                    SectionPickerView(subSectionItems: subSectionFilterItems, selectedSubSection: $selectedSubSection)
                }
                if let selectedSubSection, !selectedSubSection.isAll {
                    DetailListView(subSection: selectedSubSection)
                } else {
                    AllListView(section: section, viewModel: viewModel)
                }
            }
        }
        .onAppear {
            title = section.subTitle
            if showSubSections, selectedSubSection == nil {
                selectedSubSection = subSectionFilterItems.first
            }
        }
        .onChange(of: selectedSubSection) {
            if let selectedSubSection {
                title = selectedSubSection.title
            }
        }
    }
}

#Preview {
    AllView(section: .audio(.allAudio), subSectionFilterItems: [], viewModel: TabRootViewModel())
}
