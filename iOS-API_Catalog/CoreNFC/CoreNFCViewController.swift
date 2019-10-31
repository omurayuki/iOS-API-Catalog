import UIKit
import Foundation

final class CoreNFCViewController: UIViewController {
    
    let reader = Reader<FeliCa>()
    
    var scanBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Suica読み取り", for: .normal)
        button.layer.cornerRadius = 15
        button.layer.shadowOpacity = 0.5
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(beginScan(sender:)), for: .touchUpInside)
        return button
    }()
    
    override func loadView() {
        super.loadView()
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setup() {
        [scanBtn].forEach { view.addSubview($0) }
        
        scanBtn.anchor()
            .bottom(to: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            .centerXToSuperview()
            .width(constant: view.frame.width * 0.8)
            .height(constant: 50)
            .activate()
    }
    
    @objc func beginScan(sender: UIButton) {
        reader.read(didBecomeActive: { _ in
        }, didDetect: { reader, result in
            switch result {
            case .success(let tag):
                switch tag {
                case .edy(let edy):
                    print(edy)
                case .nanaco(let nanaco):
                    print(nanaco)
                case .waon(let waon):
                    print(waon)
                case .suica(let suica):
                    reader.setMessage("残高: \(suica.cardInformation.balance)円")
                    reader.restartReading()
                }
            case .failure(let error):
                print(error)
            }
        })
    }
}
