//
//  QueryState.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 26/09/2024.
//

import Foundation

enum QueryState: Comparable {
    case good
    case isLoading
    case loadedAll
    case noResults
    case error(String)
}
