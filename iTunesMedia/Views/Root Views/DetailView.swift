//
//  DetailView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 23/09/2024.
//

import SwiftUI

struct DetailView: View {
    @Environment(TabRootViewModel.self) private var viewModel
    
    let section: TabMainSection
    let router: Router
    
    @State private var title: String = ""
    
    var body: some View {
        @Bindable var viewModel = viewModel
        VStack {
            HeaderView(isSearching: viewModel.isSearching, lastSearchText: viewModel.lastSearchText, title: title)
                .padding(.horizontal)
            
            SearchBarView(text: $viewModel.searchText)
                .onSubmit {
                    viewModel.search()
                }
            
            DetailListView(subSection: section.subSection, router: router)
        }
        .onAppear {
            title = section.subTitle
        }
    }
}

#Preview {
    DetailView(section: .audio(.album), router: Router())
        .environment(TabRootViewModel())
}
