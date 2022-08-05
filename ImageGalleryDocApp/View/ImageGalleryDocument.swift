//
//  Document.swift
//  ImageGalleryDocApp
//
//  Created by Злобин Сергей Александрович on 23.07.2022.
//

import UIKit

class ImageGalleryDocument: UIDocument {
    
    var imageGallery: ImageGallery?
    var thumbnail: UIImage?
    
    override func contents(forType typeName: String) throws -> Any {
        
        return imageGallery?.json ?? Data()
        
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        
        if let jsonData = contents as? Data {
            imageGallery = ImageGallery(jsonData: jsonData)
        }
        
    }
    
    override func fileAttributesToWrite(to url: URL, for saveOperation: UIDocument.SaveOperation) throws -> [AnyHashable : Any] {
        
        var attributes = try super.fileAttributesToWrite(to: url, for: saveOperation)
        
        if let thumbnail = thumbnail {
            
            attributes[URLResourceKey.thumbnailDictionaryKey] = [URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey: thumbnail]
        }
        
        return attributes
        
    }
    
}

extension UIDocument.State {
    var comfortDocumentState: String {
//        return "some"
        [UIDocument.State.normal.rawValue: "normal",
         UIDocument.State.closed.rawValue: "closed",
         UIDocument.State.inConflict.rawValue: "inConflict",
         UIDocument.State.savingError.rawValue: "savingError",
         UIDocument.State.editingDisabled.rawValue: "editingDisabled",
         UIDocument.State.progressAvailable.rawValue: "progressAvailable"][Int(rawValue)] ?? String(rawValue)
    }
}

