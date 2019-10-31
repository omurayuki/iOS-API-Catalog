import UIKit
import Photos

typealias CompletionObject<T> = (_ response: T) -> Void

struct ImageStruct {
    var image: UIImage
    var imageURL: NSURL
}

class ImagePickerService: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private lazy var picker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()
    
    var completionBlock: CompletionObject<Result<ImageStruct, Error>>?
    
    func pickImage(from vc: UIViewController,
                   allowEditing: Bool = true,
                   source: UIImagePickerController.SourceType? = nil,
                   completion: CompletionObject<Result<ImageStruct, Error>>?) {
        completionBlock = completion
        picker.allowsEditing = allowEditing
        guard let source = source else {
            let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "カメラ", style: .default) { [weak self] _ in
                guard let weakSelf = self else { return }
                weakSelf.picker.sourceType = .camera
                vc.present(weakSelf.picker, animated: true)
            }
            let photoAction = UIAlertAction(title: "ライブラリ", style: .default) { [weak self] _ in
                guard let weakSelf = self else { return }
                weakSelf.picker.sourceType = .photoLibrary
                vc.present(weakSelf.picker, animated: true)
            }
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
            sheet.addAction(cameraAction)
            sheet.addAction(photoAction)
            sheet.addAction(cancelAction)
            vc.present(sheet, animated: true)
            return
        }
        picker.sourceType = source
        vc.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true) { [unowned self] in
            if let image = info[.originalImage] as? UIImage, let imageURL = info[.imageURL] as? NSURL {
                let imageStruct = ImageStruct(image: image, imageURL: imageURL)
                self.completionBlock?(.success(imageStruct))
            }
        }
    }
}
