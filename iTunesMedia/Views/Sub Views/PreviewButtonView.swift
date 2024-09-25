//
//  PreviewButton.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 25/09/2024.
//

import SwiftUI

struct PreviewButton: View {
    let url: URL
    let router: Router
    
    var body: some View {
        Button("Preview") {
            router.routeTo(.sheet) { _ in
                    SafariWebView(url:url)
            }
        }
    }
}

#Preview {
    PreviewButton(url: URL(string: "https://www.apple.com")!, router: Router())
}
