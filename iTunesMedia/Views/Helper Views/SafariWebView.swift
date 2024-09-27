//
//  SafariWebView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 25/09/2024.
//


import SwiftUI
import SafariServices

struct SafariWebView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        uiViewController.preferredControlTintColor = UIColor.green
    }
}
