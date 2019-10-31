import AVFoundation
import Foundation
import UIKit
import Photos

final class SemanticSegmentationMattesViewController: UIViewController {
    
    let imageService = ImagePickerService()
    var cfFileURL: CFURL!
    var image: UIImage?
    var imageSource: CGImageSource?
    var mattePixelBuffer: CVPixelBuffer?
    
    var resultView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(resultView)
        
        resultView.anchor()
            .centerXToSuperview()
            .width(constant: view.frame.width * 0.8)
            .top(to: view.safeAreaLayoutGuide.topAnchor, constant: 20)
            .bottom(to: view.bottomAnchor, constant: -20)
            .activate()
        
        PHPhotoLibrary.requestAuthorization({ status in
            switch status {
            case .authorized:
                let url = Bundle.main.url(forResource: "image-with-matte", withExtension: "jpg")!
                self.loadImage(at: url)
            default:
                fatalError()
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            guard let matte = self.mattePixelBuffer else {
                print("could not load image. because image has not matte info")
                return
            }
            self.draw(pixelBuffer: matte)
        }
    }
    
    private func loadImage(at url: URL) {
        self.imageSource = CGImageSourceCreateWithURL(url as CFURL, nil)!
        self.getPortraitMatte()
        guard let image = UIImage(contentsOfFile: url.path) else { fatalError() }
        self.image = image
        self.drawImage(image)
    }
    
    private func loadAsset(_ asset: PHAsset) {
        asset.requestColorImage { image in
            self.image = image
            self.drawImage(image)
        }
        asset.requestContentEditingInput(with: nil) { contentEditingInput, info in
            self.imageSource = contentEditingInput?.createImageSource()
            self.getPortraitMatte()
        }
    }
    
    private func getPortraitMatte() {
        var depthDataMap: CVPixelBuffer? = nil
        if let matteData = imageSource?.getMatteData() {
            depthDataMap = matteData.mattingImage
        }
        mattePixelBuffer = depthDataMap
    }
    
    private func drawImage(_ image: UIImage?) {
        DispatchQueue.main.async { [unowned self] in
            self.resultView.image = image
        }
    }
    
    private func draw(pixelBuffer: CVPixelBuffer?) {
        var image: UIImage? = nil
        if let pixelBuffer = pixelBuffer {
            if let depthMapImage = UIImage(pixelBuffer: pixelBuffer) {
                image = depthMapImage
            }
        }
        drawImage(image)
    }
}
