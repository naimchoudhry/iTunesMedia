//
//  TabRootView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 21/09/2024.
//

import SwiftUI

struct TabRootView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(TabRootViewModel.self) private var viewModel
    
    @State var selection: TabMainSection = .all
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(TabMainSection.mainSections) { section in
                if horizontalSizeClass == .regular, let subSections = section.subSections {
                    TabSection  {
                        ForEach(subSections) { subSection in
                            Tab(subSection.subTitle, systemImage: subSection.subImage, value: subSection) {
                                tabView(section: subSection, filterItems: [])
                            }
                        }
                    } header: {
                        Label(section.title, systemImage: section.image)
                    }
                } else {
                    Tab(section.title, systemImage: section.image, value: section) {
                        tabView(section: section, filterItems: section.subSectionFilterItems)
                    }
                }
            }
        }
        .tint(.green)
        .tabViewStyle(.sidebarAdaptable)
        .onAppear {
            viewModel.searchLast()
        }
    }
    
    @ViewBuilder func tabView(section: TabMainSection, filterItems: [TabSubSection]) -> some View {
        Router.startRoute { router in
            if section.isAll {
                AllView(section: section, subSectionFilterItems: filterItems, router: router)
            } else {
                DetailView(section: section, router: router)
            }
        }.view
    }
}

#Preview {
    TabRootView()
        .environment(TabRootViewModel())
}
