//
//  DocumentBrowserViewController.swift
//  ImageGalleryDocApp
//
//  Created by Злобин Сергей Александрович on 23.07.2022.
//

import UIKit


class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    // MARK: Private implementation
    
    var template: URL?
    
    // MARK: ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        allowsDocumentCreation = false
        allowsPickingMultipleItems = false
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let url = try? FileManager.default.url(for: .applicationSupportDirectory,
                                                 in: .userDomainMask,
                                                 appropriateFor: nil,
                                                 create: true) {
                template = url.appendingPathComponent("Gallery.imageGallery")
                            
            }
            
            if let url = template {
                allowsDocumentCreation = FileManager.default.createFile(atPath: url.path,
                                                                        contents: ImageGallery(title: "Gallery",
                                                                                               images: []).json)
            }
        }
        
    }
    
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        
        importHandler(template!, .copy)
        
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let imageGalleryDocument = storyBoard.instantiateViewController(withIdentifier: "ImageGalleryDocument")
        
        if let docMVC = imageGalleryDocument.contents as? imageGalleryViewController {
            docMVC.document = ImageGalleryDocument(fileURL: documentURL)
        }
            
        present(imageGalleryDocument, animated: true)
                
    }
}

