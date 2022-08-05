//
//  DocumenInfoViewController.swift
//  ImageGalleryDocApp
//
//  Created by Злобин Сергей Александрович on 05.08.2022.
//

import UIKit

class DocumenInfoViewController: UIViewController {

    // MARK: - API, Model
    
    var document: ImageGalleryDocument? {
        didSet{
            UpdateUI()
        }
    }
    
    // MARK: - ViewController life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateUI()
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if presentationController is UIPopoverPresentationController {
            let fittedSize = topLevelStackView.sizeThatFits(UIView.layoutFittingCompressedSize)
            preferredContentSize = CGSize(width: fittedSize.width + 30,
                                                  height: fittedSize.height + 30)

        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var topLevelStackView: UIStackView!
    @IBOutlet weak var ReturnToDocument: UIButton!
    @IBOutlet private var thumbNailImageAspectRatio: NSLayoutConstraint!
    @IBOutlet weak private var thumbNailImageView: UIImageView!
    @IBOutlet weak private var createdLabel: UILabel!
    @IBOutlet weak private var sizeLabel: UILabel!
    @IBAction private func done() {
        presentingViewController?.dismiss(animated: true)
    }
        
    // MARK: - Private implementation
    private var dateFormatter: DateFormatter = {
       var dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    private func UpdateUI() {
        
        if sizeLabel != nil, createdLabel != nil,
           let url = document?.fileURL, let attributes = try? FileManager.default.attributesOfItem(atPath: url.path) {
            
            sizeLabel.text = "\(attributes[.size] ?? 0) bytes"
            if let created = attributes[.creationDate] as? Date {
                createdLabel.text = dateFormatter.string(from: created)
            }
            
        }
        
        if thumbNailImageView != nil, thumbNailImageAspectRatio != nil, let thumbImage = document?.thumbnail {
            thumbNailImageView.image = thumbImage
            
            thumbNailImageView.removeConstraint(thumbNailImageAspectRatio)
            
            thumbNailImageAspectRatio = NSLayoutConstraint(
                item: thumbNailImageView!,
                attribute: .width,
                relatedBy: .equal,
                toItem: thumbNailImageView,
                attribute: .height,
                multiplier: thumbImage.size.width / thumbImage.size.height,
                constant: 0
            )
            
            thumbNailImageView.addConstraint(thumbNailImageAspectRatio)
            
            if presentationController is UIPopoverPresentationController {
                thumbNailImageView.isHidden = true
                ReturnToDocument.isHidden = true
                view.backgroundColor = .clear
            }
            
        }
                
    }

}
