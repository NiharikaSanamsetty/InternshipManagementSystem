 

import Foundation
import Foundation
import UIKit
import PDFKit
import UniformTypeIdentifiers


public protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?, name: String?)
    func didSelect(pdf: PDFDocument?, path: URL)
}

open class ImagePicker: NSObject {

    public let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    public func present(from sourceView: UIView) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        /*
        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        */
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "PDF", style: .default, handler: { _ in
            if #available(iOS 14.0, *) {
                let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf ])
                documentPicker.delegate = self
            documentPicker.modalPresentationStyle = .formSheet

            self.presentationController?.present(documentPicker, animated: true)
            } else {
                // Fallback on earlier versions
            }
            
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?, name: String?) {
        controller.dismiss(animated: true, completion: nil)

        self.delegate?.didSelect(image: image, name: name)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil, name: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            let name = (info[UIImagePickerController.InfoKey.imageURL] as? URL)?.lastPathComponent
            return self.pickerController(picker, didSelect: (info[.originalImage] as! UIImage) , name: name)
        }
        let name = (info[UIImagePickerController.InfoKey.imageURL] as? URL)?.lastPathComponent
        self.pickerController(picker, didSelect: image, name: name)
    }
}

extension ImagePicker: UINavigationControllerDelegate {

}
extension ImagePicker: UIDocumentPickerDelegate {

    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first, url.startAccessingSecurityScopedResource() else {
            return
        }
        print("URL: \(url)")
        if let document = PDFDocument(url: url) {
            print("Doc: \(document)")
            self.delegate?.didSelect(pdf: document, path: url)
        }
        do {
            url.stopAccessingSecurityScopedResource()
        }
        
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {

    }
}
