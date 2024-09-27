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
    
    var body: some View {
        
        AsyncImage(url: URL(string: urlString)) { phase in
            if let image = phase.image {
                image
                    .frame(width: size, alignment: .center)
                    .iflet(rounding) { view, rounding in
                        view.clipShape(RoundedRectangle(cornerRadius: rounding))
                    }
            } else if phase.error != nil {
                Color.gray
                    .frame(width: size)
                    .opacity(0.1)
                    .iflet(rounding) { view, rounding in
                        view.clipShape(RoundedRectangle(cornerRadius: rounding))
                    }
                    .task {
                        //print("Image Error", phase.error)
                    }
                
            } else {
                ProgressView()
                    .frame(width: size)
            }
        }
        .frame(height: size)
    }
}

#Preview {
    ImageLoadView(urlString: "", size: 100, rounding: nil)
}
