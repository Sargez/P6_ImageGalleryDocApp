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
    
    // MARK: - Outlets
    
    @IBOutlet private var thumbNailImageAspectRatio: NSLayoutConstraint!
    @IBOutlet weak private var thumbNailImageView: UIImageView!
    @IBOutlet weak private var createdLabel: UILabel!
    @IBOutlet weak private var sizeLabel: UILabel!
    @IBAction private func done() {
        presentingViewController?.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
            
            sizeLabel.text = "\(attributes[.size] ?? 0)"
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
            
        }
        
    }

}
