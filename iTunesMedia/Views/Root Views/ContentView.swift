//
//  ContentView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 21/09/2024.
//

import SwiftUI

struct ContentView: View {
    let tabRootViewModel = TabRootViewModel()
    
    var body: some View {
        TabRootView()
            .environment(tabRootViewModel)
    }
}

#Preview {
    ContentView()
}
