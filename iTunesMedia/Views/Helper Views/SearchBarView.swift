//
//  SearchBar.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 21/09/2024.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    @FocusState private var isFocused
    @State private var cancelButtonShown = false
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .focused($isFocused)
                .submitLabel(.search)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        Button(action: {
                            withAnimation {
                                self.text = ""
                            }
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                        
                    }
                )
                .padding(.horizontal)
                .onChange(of: text) {
                    cancelButtonShown = !text.isEmpty
                }
            
            if cancelButtonShown {
                Button("Cancel", role: .cancel) {
                    withAnimation {
                        self.isFocused = false
                        self.text = ""
                        self.cancelButtonShown = false
                    }
                }
                .padding(5)
                .background(.tint)
                .foregroundColor(.white)
                .cornerRadius(5)
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing).combined(with: .scale(0.1)))
            }
        }
        .animation(.easeInOut, value: cancelButtonShown)
    }
}

#Preview {
    SearchBarView(text: .constant(""))
}
