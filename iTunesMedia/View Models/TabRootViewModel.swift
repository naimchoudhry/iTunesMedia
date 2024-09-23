//
//  TabRootViewModel.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 21/09/2024.
//

import SwiftUI

@Observable
class TabRootViewModel {
    
    deinit {
        print("TabRootViewModel deinit")
    }
    var searchText: String = ""
    var selectedTab: TabMainSection = .all
    
    var tabHandler: Binding<TabMainSection> {
        Binding(
            get: {self.selectedTab},
            set: {
                if $0 == self.selectedTab {
                    //self.popToRootTab = $0
                }
                self.selectedTab = $0
//                if self.selectedTab != self.settings.lastSelectedTab, self.selectedTab != .more {
//                    self.settings.lastSelectedTab = self.selectedTab
//                }
            })
    }
    
}
