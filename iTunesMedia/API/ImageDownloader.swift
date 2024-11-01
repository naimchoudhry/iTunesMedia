//
//  ImageDownloader.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 09/10/2024.
//

import Foundation
import SwiftUI

enum ImageDownloadError: Error {
    case invalidURL
    case invalidData
}

actor ImageDownloader {
    typealias ImageResult = (UIImage, Bool) /// The returned image and true if cached image was used
    
    private enum CacheEntry {
        case inProgress(Task<UIImage, Error>)
        case ready(UIImage)
    }
    
    static let shared = ImageDownloader()
    private let session: URLSession
    private var cache: [String: CacheEntry] = [:]
    
    private init() {
        let config = URLSessionConfiguration.default
        config.urlCache = URLCache(memoryCapacity: 500_000_000, diskCapacity: 1_000_000_000)
        session = URLSession(configuration: config)
        Task {
            await listenForMemoryPressureWarnings()
        }
    }

    func image(from urlString: String) async throws -> ImageResult {
        if let cached = cache[urlString] {
            switch cached {
            case .ready(let image):
                return (image, true)
            case .inProgress(let task):
                return try await (task.value, false)
            }
        }
        
        let task = Task {
            guard let url = URL(string: urlString) else {
                throw ImageDownloadError.invalidURL
            }
            
            let (data, _) = try await session.data(from: url)
            
            if let image = UIImage(data: data) {
                cache[urlString] = .ready(image)
                return image
            } else {
                throw ImageDownloadError.invalidData
            }
        }
        
        cache[urlString] = .inProgress(task)
        
        do {
            let image = try await task.value
            cache[urlString] = .ready(image)
            return (image, false)
        } catch {
            cache[urlString] = nil
            throw error
        }
    }
    
    func listenForMemoryPressureWarnings() async {
        for await _ in NotificationCenter.default.notifications(named: UIApplication.didReceiveMemoryWarningNotification) {
            self.purgeCache()
        }
    }
    
    func purgeCache() {
        cache.removeAll()
    }
}
