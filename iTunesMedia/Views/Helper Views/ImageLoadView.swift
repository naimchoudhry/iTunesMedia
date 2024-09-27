//
//  ImageLoadView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 23/09/2024.
//

import SwiftUI

struct ImageLoadView: View {
    
    @State var urlString: String
    let size: CGFloat
    let rounding: CGFloat?
    @State private var error = false
    
    var body: some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            if let image = phase.image {
                image
                    .frame(width: size, alignment: .center)
                    .iflet(rounding) { view, rounding in
                        view.clipShape(RoundedRectangle(cornerRadius: rounding))
                    }
                    .task {
                        error = false
                    }
            } else if phase.error != nil {
                Color.gray
                    .frame(width: size)
                    .opacity(0.1)
                    .iflet(rounding) { view, rounding in
                        view.clipShape(RoundedRectangle(cornerRadius: rounding))
                    }
                    .task {
                        error = true
                        swapDelay()
                    }
                
            } else {
                ProgressView()
                    .frame(width: size)
                    .task {
                        error = false
                    }
            }
        }
        .onAppear {
            if error {
                swapDelay()
            }
        }
        .frame(height: size)
    }
    
    // Workaround for image loads being cancelled in lazy container views
    func swapDelay() {
        let swap = urlString
        urlString = ""
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            urlString = swap
        }
    }
}

#Preview {
    ImageLoadView(urlString: "", size: 100, rounding: nil)
}
