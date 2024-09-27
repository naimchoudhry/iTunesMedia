//
//  PreviewButton.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 25/09/2024.
//

import SwiftUI

struct PreviewButtonView: View {
    
    let url: URL
    let router: Router
    var hideImage: Bool = true
    
    var body: some View {
        if hideImage {
            Button("Preview") {
                router.routeTo(.sheet) { _ in
                        SafariWebView(url:url)
                }
            }
        } else {
            Button("Preview", systemImage: "\(hideImage ? "" : "tv.and.mediabox")") {
                router.routeTo(.sheet) { _ in
                    SafariWebView(url:url)
                }
            }
        }
    }
}

#Preview {
    PreviewButtonView(url: URL(string: "https://www.apple.com")!, router: Router())
}
