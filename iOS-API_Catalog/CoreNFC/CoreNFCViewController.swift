import CoreNFC
import UIKit
import Foundation

final class SuicaCell: UITableViewCell {
    
    var date: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var entranceStation: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var exitStation: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var balance: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setup() {
        [date, entranceStation, exitStation, balance].forEach { addSubview($0) }
        
        date.anchor()
            .top(to: topAnchor, constant: 10)
            .left(to: leftAnchor, constant: 20)
            .activate()
        
        entranceStation.anchor()
            .top(to: date.bottomAnchor, constant: 10)
            .left(to: leftAnchor, constant: 20)
            .activate()
        
        exitStation.anchor()
            .top(to: date.bottomAnchor, constant: 10)
            .left(to: entranceStation.rightAnchor, constant: 15)
            .activate()
        
        balance.anchor()
            .top(to: entranceStation.bottomAnchor, constant: 10)
            .left(to: leftAnchor, constant: 20)
            .bottom(to: bottomAnchor, constant: -10)
            .activate()
    }
    
    func configure(date: String?, entrance: String?, exit: String?, balance: String?) {
        self.date.text = "日付: \(date ?? "")"
        self.entranceStation.text = "入場口: \(entrance ?? "")"
        self.exitStation.text = "出場口: \(exit ?? "")"
        self.balance.text = "残高: \(balance ?? "")"
    }
}

final class CoreNFCViewController: UIViewController {
    
    var session: NFCTagReaderSession?
    
    var dataTuple: [(date: String?, entrance: String?, exit: String?, balance: String?)]? {
        didSet {
            tableview.reloadData()
        }
    }
    
    var tableview: UITableView = {
        let table = UITableView()
        table.register(SuicaCell.self, forCellReuseIdentifier: String(describing: SuicaCell.self))
        return table
    }()
    
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
        view.backgroundColor = .white
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    func setup() {
        [tableview, scanBtn].forEach { view.addSubview($0) }
        
        tableview.anchor()
            .edgesToSuperview()
            .activate()
        
        scanBtn.anchor()
            .bottom(to: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            .centerXToSuperview()
            .width(constant: view.frame.width * 0.8)
            .height(constant: 50)
            .activate()
    }
    
    func beginScanning() {
        self.session = NFCTagReaderSession(pollingOption: .iso18092, delegate: self)
        self.session?.alertMessage = "iPhoneをSuicaに近ずけてください"
        self.session?.begin()
    }
    
    @objc func beginScan(sender: UIButton) {
        beginScanning()
    }
}

extension CoreNFCViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTuple?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SuicaCell.self), for: indexPath) as? SuicaCell else { return UITableViewCell() }
        let data = dataTuple?[indexPath.row]
        cell.configure(date: data?.date, entrance: data?.entrance, exit: data?.exit, balance: data?.balance)
        return cell
    }
}

extension CoreNFCViewController: NFCTagReaderSessionDelegate {
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("tagReaderSessionDidBecomeActive(_:)")
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        if let readerError = error as? NFCReaderError {
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                let alertController = UIAlertController(
                    title: "Session Invalidated",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        self.session = nil
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard case .feliCa(_) = tags.first else { return }
        guard let tag = tags.first else { return }
        session.connect(to: tag, completionHandler: { error in
            guard error == nil else { return }
            let serviceCodeList = [Data([0x0f, 0x09])]
            let blockList = (0 ..< UInt8(10)).map { Data([0x08, $0]) }
            
        })
    }
    
    
}
