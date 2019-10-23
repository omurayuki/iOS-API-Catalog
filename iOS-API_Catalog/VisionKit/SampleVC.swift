import UIKit

final class SampleVC: UIViewController {
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        
        imageView.anchor()
        .edgesToSuperview()
        .activate()
    }
}
