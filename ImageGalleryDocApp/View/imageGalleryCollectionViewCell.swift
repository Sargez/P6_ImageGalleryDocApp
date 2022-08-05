//
//  imageGalleryCollectionViewCell.swift
//  imageGallery
//
//  Created by 1C on 09/07/2022.
//

import UIKit

class imageGalleryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public API
    var imageUrl: URL?{
        didSet{
            imageView.image = nil
            configureCell()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //MARK: - Private implementation
    
    private func configureCell() {
            
        if let url = imageUrl {
            
            spinner.startAnimating()
            
            fetcher.fetchImage(from: url) { [weak self] url, imageResult, error in
                DispatchQueue.main.async {
                    self?.spinner.stopAnimating()
                    guard let image = imageResult else {
                        
                        if url == self?.imageUrl {
                            self?.imageView.image = UIImage(named: "FailedAttempt",
                                                            in: Bundle(for: self!.classForCoder),
                                                            compatibleWith: self?.traitCollection)
                        }
                        return
                        
                    }
                    if url == self?.imageUrl {
                        self?.imageView.image = image
                    }
                }
            }
            
            //+load via DispatchWorkItem
            //        var data: Data?
            //
            //        let concurrentQueue = DispatchQueue.global(qos: .userInitiated)
            //
            //        let workItem = DispatchWorkItem {
            //            data = try? Data(contentsOf: url)
            //        }
            //
            //        concurrentQueue.async(execute: workItem)
            //
            //        workItem.notify(queue: DispatchQueue.main) { [weak self] in
            //            if let imageData = data {
            //                self?.imageView.image = UIImage(data: imageData)
            //            }
            //        }
            //-load via DispatchWorkItem
                        
            //+load via asyncLoadImage handler
            //asyncLoadImage(imageUrl: url,
            //               loadQueue: DispatchQueue.global(qos: .userInitiated),
            //               completionQueue: DispatchQueue.main)
            //{
            //    [weak self] result, error in
            //    self?.spinner.stopAnimating()
            //    guard let image = result else {
            //
            //        if url == self?.imageUrl {
            //            self?.imageView.image = UIImage(named: "FailedAttempt",
            //                                            in: Bundle(for: self!.classForCoder),
            //                                            compatibleWith: self?.traitCollection)
            //        }
            //        return
            //
            //    }
            //    if url == self?.imageUrl {
            //        self?.imageView.image = image
            //    }
            //}
            //-load via asyncLoadImage handler
        }
        
    }
    
    private var fetcher: Fetcher = {
        Fetcher()
    }()
    
//    private func asyncLoadImage(imageUrl: URL,
//                                loadQueue: DispatchQueue,
//                                completionQueue: DispatchQueue,
//                                completionHandler: @escaping (UIImage?, Error?) -> ()) {
//
//        loadQueue.async {
//            do {
//                let data = try Data(contentsOf: imageUrl)
//                completionQueue.async {completionHandler(UIImage(data: data), nil)}
//            } catch let error {
//                completionQueue.async {
//                    completionHandler(nil, error)
//                }
//            }
//        }
//    }
    
}
