//
//  Fetcher.swift
//  imageGallery
//
//  Created by Злобин Сергей Александрович on 23.07.2022.
//

import Foundation
import UIKit

class Fetcher {
    
    // MARK: Public API
    
    func fetchImage(from url: URL, complitionHandler handler: @escaping (URL, UIImage?, Error?) -> Void) {
        
        let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        
        if let cache = cacheURL, let cacheResponse = cache.cachedResponse(for: urlRequest), let image = UIImage(data: cacheResponse.data) {
            
            handler(url,image,nil)
          
        } else {
            let task = URLSession.shared.dataTask(with: urlRequest) {[weak self] data, response, error in
                
                if let imageContent = data, let urlResponse = response {
                    
                    let cacheURLResponse = CachedURLResponse(response: urlResponse, data: imageContent, storagePolicy: .allowed)
                    self?.cacheURL?.storeCachedResponse(cacheURLResponse, for: urlRequest)
                    
                    handler(url, UIImage(data: imageContent), nil)
                } else {
                    handler(url, nil, error)
                }
                
            }
            task.resume()
        }
    }
        
    init(url: URL, handler: @escaping (URL, UIImage?, Error?) -> Void) {
        self.handler = handler
        setupCache()
        fetchImage(from: url, complitionHandler: handler)
    }
    
    init(handler: @escaping (URL, UIImage?, Error?) -> Void) {
        self.handler = handler
        setupCache()
    }
    
    init() {
        setupCache()
    }
        
    // MARK: Private implementation
    private func setupCache() {
        if let cacheDirectory = try? FileManager.default.url(for: .cachesDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create: true) {
            cacheURL = URLCache(memoryCapacity: Constants.memoryCapacity,
                                         diskCapacity: Constants.diskCapacity,
                                         directory: cacheDirectory)
        } else {
            cacheURL = nil
        }
    }
    private var cacheURL: URLCache?
    private var handler: ((URL, UIImage?, Error?) -> Void)?

}

private struct Constants {
    static let memoryCapacity: Int = 104857600 //100Mb in bytes
    static let diskCapacity: Int = 104857600 //100Mb in bytes
}
