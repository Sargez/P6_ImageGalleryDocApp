//
//  ImagePlaceHolderCollectionViewCell.swift
//  imageGallery
//
//  Created by 1C on 10/07/2022.
//

import UIKit

class ImagePlaceHolderCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var labelText: UILabel!
    
    // MARK: - Public implementation
    func configureCell() {
           
        labelText.attributedText = NSAttributedString(string: "wait please...")
        self.isUserInteractionEnabled = false
        self.isMultipleTouchEnabled = false
                
    }
    
}
