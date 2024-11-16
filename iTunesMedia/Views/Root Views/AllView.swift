//
//  AllView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 23/09/2024.
//

import SwiftUI

struct AllView: View {
    @Environment(TabRootViewModel.self) private var viewModel
    
    let section: TabMainSection
    let subSectionFilterItems: [TabSubSection]
    let router: Router
    
    @State private var title: String = ""
    @State private var selectedSubSection: TabSubSection?
    
    private var showSubSections: Bool {
        !subSectionFilterItems.isEmpty
    }
    
    var body: some View {
        @Bindable var viewModel = viewModel
        VStack {
            HeaderView(isSearching: viewModel.isSearching, lastSearchText: viewModel.lastSearchText, title: title)
                .padding(.horizontal)
            
            SearchBarView(text: $viewModel.searchText)
                .onSubmit {
                    withAnimation {
                        viewModel.search()
                    }
                }
            
            if showSubSections {
                SectionPickerView(subSectionItems: subSectionFilterItems, selectedSubSection: $selectedSubSection)
            }
            
            if let selectedSubSection, !selectedSubSection.isAll {
                DetailListView(subSection: selectedSubSection, router: router)
            } else {
                AllListView(section: section, router: router)
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
    AllView(section: .audio(.allAudio), subSectionFilterItems: [], router: Router())
        .environment(TabRootViewModel())
}
