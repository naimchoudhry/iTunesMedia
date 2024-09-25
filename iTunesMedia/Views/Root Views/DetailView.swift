//
//  DetailView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 23/09/2024.
//

import SwiftUI

struct DetailView: View {
    let section: TabMainSection
    @Bindable var viewModel: TabRootViewModel
    @State private var title: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                HeaderView(isSearching: $viewModel.isSearching, lastSearchText: $viewModel.lastSearchText, title: $title)
                    .padding(.horizontal)
                
                SearchBarView(text: $viewModel.searchText)
                    .onSubmit {
                        viewModel.search()
                    }
                
                DetailListView(subSection: section.subSection, viewModel: viewModel)
            }
        }
        .onAppear {
            title = section.subTitle
        }
    }
}

#Preview {
    DetailView(section: .audio(.album), viewModel: TabRootViewModel())
}
