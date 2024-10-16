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

@MainActor
class UserStorage: ObservableObject {
    @AppStorage(AppStorageKey.lastSearchTerm) var lastSearchTerm: String = "Goodnotes"
    
    static let shared = UserStorage()
    private init() {}
}
