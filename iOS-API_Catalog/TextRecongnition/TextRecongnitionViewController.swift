import Foundation
import UIKit
import Vision
import VisionKit

final class TextRecongnitionViewController: UIViewController, VNDocumentCameraViewControllerDelegate {
    
    var textRecognitionRequest = VNRecognizeTextRequest(completionHandler: nil)
    private let textRecognitionWorkQueue = DispatchQueue(label: "TextRecognitionQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    var imageView: BoundingBoxImageView = {
        let image = BoundingBoxImageView()
        return image
    }()
    
    var textView: UITextView = {
        let text = UITextView()
        return text
    }()
    
    var scanBtn: UIButton = {
        let button = UIButton()
        button.setTitle("文字認識", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(scanDocument), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupVision()
    }
    
    @objc func scanDocument() {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = self
        present(scannerViewController, animated: true)
    }
}

extension TextRecongnitionViewController {
    
    func setup() {
        [imageView, textView, scanBtn].forEach { view.addSubview($0) }
        
        imageView.anchor()
            .centerXToSuperview()
            .width(constant: view.frame.width * 0.8)
            .height(constant: 400)
            .top(to: view.safeAreaLayoutGuide.topAnchor)
            .activate()
        
        textView.anchor()
            .centerXToSuperview()
            .width(constant: view.frame.width * 0.8)
            .height(constant: 150)
            .top(to: imageView.bottomAnchor, constant: 20)
            .activate()
        
        scanBtn.anchor()
            .width(constant: view.frame.width * 0.8)
            .centerXToSuperview()
            .bottom(to: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            .height(constant: 50)
            .activate()
    }
    
    func setupVision() {
            textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                
                var detectedText = ""
                var boundingBoxes = [CGRect]()
                for observation in observations {
                    guard let topCandidate = observation.topCandidates(1).first else { return }
                    
                    detectedText += topCandidate.string
                    detectedText += "\n"
                    
                    do {
                        guard let rectangle = try topCandidate.boundingBox(for: topCandidate.string.startIndex..<topCandidate.string.endIndex) else { return }
                        boundingBoxes.append(rectangle.boundingBox)
                    } catch {
                        // You should handle errors appropriately in your app
                        print(error)
                    }
                }
                
                DispatchQueue.main.async {
                    self.scanBtn.isEnabled = true
                    
                    self.textView.text = detectedText
                    self.textView.flashScrollIndicators()
                    
                    self.imageView.load(boundingBoxes: boundingBoxes)
                }
            }
            textRecognitionRequest.recognitionLevel = .accurate
        }
    
    func processImage(_ image: UIImage) {
        imageView.image = image
        imageView.removeExistingBoundingBoxes()
        
        recognizeTextInImage(image)
    }
    
    func recognizeTextInImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        textView.text = ""
        scanBtn.isEnabled = false
        
        textRecognitionWorkQueue.async {
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try requestHandler.perform([self.textRecognitionRequest])
            } catch {
                print(error)
            }
        }
    }
    
    
    // MARK: - VNDocumentCameraViewControllerDelegate

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        // Make sure the user scanned at least one page
        guard scan.pageCount >= 1 else {
            // You are responsible for dismissing the VNDocumentCameraViewController.
            controller.dismiss(animated: true)
            return
        }
        
        // This is a workaround for the VisionKit bug which breaks the `UIImage` returned from `VisionKit`
        // See the `Image Loading Hack` section below for more information.
        let originalImage = scan.imageOfPage(at: 0)
        let fixedImage = reloadedImage(originalImage)
        
        // You are responsible for dismissing the VNDocumentCameraViewController.
        controller.dismiss(animated: true)
        
        // Process the image
        processImage(fixedImage)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        // The VNDocumentCameraViewController failed with an error.
        // For now, we'll print it, but you should handle it appropriately in your app.
        print(error)
        
        // You are responsible for dismissing the VNDocumentCameraViewController.
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        // You are responsible for dismissing the VNDocumentCameraViewController.
        controller.dismiss(animated: true)
    }
    
    // MARK: - Image Loading Hack
    
    /// VisionKit currently has a bug where the images returned reference unique files on disk which are deleted after dismissing the VNDocumentCameraViewController.
    /// To work around this, we have to create a new UIImage from the data of the original image from VisionKit.
    /// I have filed a bug (FB6156927) - hopefully this is fixed soon.
    
    func reloadedImage(_ originalImage: UIImage) -> UIImage {
        guard let imageData = originalImage.jpegData(compressionQuality: 1),
            let reloadedImage = UIImage(data: imageData) else {
                return originalImage
        }
        return reloadedImage
    }
}
