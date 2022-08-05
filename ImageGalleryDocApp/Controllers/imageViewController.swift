//
//  imageViewController.swift
//  imageGallery
//
//  Created by 1C on 09/07/2022.
//

import UIKit

class imageViewController: UIViewController, UIScrollViewDelegate {

    //MARK: - public API
    
    var imageURL: URL? {
        didSet {
            backGroundImage = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    //MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if backGroundImage == nil, imageURL != nil {
            fetchImage()
        }
        
    }
    
    //MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 10.0
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var scrollViewConstraintByWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollViewConstraintByHeight: NSLayoutConstraint!
    
    //MARK: - Scroll view delegate methods
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
        
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewConstraintByWidth.constant = scrollView.contentSize.width
        scrollViewConstraintByHeight.constant = scrollView.contentSize.height
    }
        
    //MARK: - Private implementation
    
    private var imageView = UIImageView()
    
    private var backGroundImage: UIImage? {
        get{
            return imageView.image
        }
        set {
            scrollView?.zoomScale = 1.0
            imageView.image = newValue
            let size = newValue?.size ?? CGSize.zero
            imageView.sizeToFit()
            scrollView?.contentSize = size
            scrollView?.addSubview(imageView)
            scrollView?.zoomScale = max(view.bounds.width/scrollView.contentSize.width,
                                       view.bounds.height/scrollView.contentSize.height)
            scrollViewConstraintByWidth?.constant = scrollView.contentSize.width
            scrollViewConstraintByHeight?.constant = scrollView.contentSize.height
            spinner?.stopAnimating()
        }
    }
    
    private func fetchImage() {
        
        if let url = imageURL {
            spinner.startAnimating()
            
            fetcher.fetchImage(from: url) { [weak self] url, image, error in
                DispatchQueue.main.async {
                    if let currentUrl = self?.imageURL, currentUrl == url {
                        self?.backGroundImage = image
                    }
                }
            }
                        
//            asyncLoadImage(url: url,
//                           complitionQueue: DispatchQueue.main,
//                           complitionHandler:
//                            { [weak self] image, error in
//                                if let currentUrl = self?.imageURL, currentUrl == url {
//                                    self?.backGroundImage = image
//                                }
//                            })
        }
        
    }

    private var fetcher: Fetcher = {
        Fetcher()
    }()
    
//    private func asyncLoadImage(url: URL,
//                                complitionQueue: DispatchQueue,
//                                complitionHandler: @escaping (UIImage?,  Error?) -> Void) {
//
//        let urlRequest = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 30)
//
//        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//            complitionQueue.async {
//                if let imageContent = data {
//                    complitionHandler(UIImage(data: imageContent), nil)
//                } else {
//                    complitionHandler(nil, error)
//                }
//            }
//
//        }
//        task.resume()
//    }
    
}
