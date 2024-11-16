//
//  ImageLoadView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 23/09/2024.
//

import SwiftUI

struct ImageLoadView: View {
    let urlString: String
    let size: CGFloat
    let rounding: CGFloat?
    
    @State private var uiImage: UIImage? = nil
    @State private var imageDownloadError = false
    @State private var cached = false
    
    var body: some View {
        Group {
            if let image = uiImage {
                Image(uiImage: image)
                    .iflet(rounding) { view, rounding in
                        view.clipShape(RoundedRectangle(cornerRadius: rounding))
                    }
                    .if(!cached) {
                        $0.transition(.opacity.combined(with: .scale(0.65)).animation(.easeInOut))
                    }
            } else if imageDownloadError {
                Color.gray
                    .opacity(0.1)
                    .iflet(rounding) { view, rounding in
                        view.clipShape(RoundedRectangle(cornerRadius: rounding))
                    }
            } else {
                Color.clear
            }
        }
        .frame(width: size, height: size)
        .task {
            do {
                (uiImage, cached) = try await ImageDownloader.shared.image(from: urlString)
            } catch {
                imageDownloadError = true
            }
        }
    }
}

#Preview {
    ImageLoadView(urlString: "", size: 100, rounding: nil)
}
