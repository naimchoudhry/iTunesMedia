//
//  TabRootView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 21/09/2024.
//

import SwiftUI

struct TabRootView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var tabRootViewModel = TabRootViewModel()
    
    var body: some View {
        TabView(selection: tabRootViewModel.tabHandler) {
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
        .tabViewStyle(.sidebarAdaptable)
    }
    
    @ViewBuilder func tabView(section: TabMainSection, filterItems: [TabSubSection]) -> some View {
        if section.isAll {
            AllView(section: section, subSectionFilterItems: filterItems, viewModel: tabRootViewModel)
        } else {
            DetailView(section: section)
        }
    }
}

#Preview {
    TabRootView()
}
