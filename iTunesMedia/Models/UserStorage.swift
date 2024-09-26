//
//  UserStorage.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 25/09/2024.
//

import SwiftUI

enum AppStorageKey {
    static let lastSearchTerm = "lastSearchTerm"
}

class UserStorage: ObservableObject {
    @AppStorage(AppStorageKey.lastSearchTerm) var lastSearchTerm: String = "Loyds"
    
    static let shared = UserStorage()
    private init() {}
}
