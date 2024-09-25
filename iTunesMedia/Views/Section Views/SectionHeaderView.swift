//
//  SectionHeaderView.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 23/09/2024.
//

import SwiftUI

struct SectionHeaderView: View {
    let title: String
    var action: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
            Spacer()
            Group {
                Text("See All")
                Image(systemName: "chevron.right")
            }
            .disabled(action == nil)
            .foregroundStyle(.tint)
            .contentShape(.rect)
            .onTapGesture {
                action?()
            }
            
        }
        .padding(.horizontal)
    }
}

#Preview {
    SectionHeaderView(title: "Section Header", action: {})
}
