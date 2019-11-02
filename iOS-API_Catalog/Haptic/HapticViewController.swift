import Foundation
import UIKit
import CoreHaptics

final class HapticViewController: UIViewController {
    
    var hapticEngine: CHHapticEngine?
    
    var hapticBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Haptic", for: .normal)
        button.layer.cornerRadius = 15
        button.backgroundColor = .systemBlue
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(hapticBtn)
        hapticBtn.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        
        hapticBtn.anchor()
            .bottom(to: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            .width(constant: view.frame.width * 0.8)
            .height(constant: 50)
            .centerXToSuperview()
            .activate()
        setupHapticEngine()
    }
    
    @objc func tapped(_ sender: UIButton) {
        playHapticEngine()
    }
}

extension HapticViewController {
    
    func setupHapticEngine() {
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("There was an error creating the engine")
        }

        hapticEngine?.stoppedHandler = { reason in
            print("The engine stopped")
        }

        hapticEngine?.resetHandler = { [weak self] in
            print("The engine reset")
                
            do {
                try self?.hapticEngine?.start()
            } catch {
                print("Failed to restart the engine")
            }
        }
    }
    
    func playHapticEngine() {
        do {
            let hapticPattern = try CHHapticPattern(events: createHapticEvents3(), parameters: [])
            let hapticPlayer = try hapticEngine?.makePlayer(with: hapticPattern)
            try hapticPlayer?.start(atTime: 0)
        } catch {
            print("Failed to play")
        }
    }
    
    func createHapticEvents1() -> [CHHapticEvent] {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        return [event]
    }
    
    func createHapticEvents2() -> [CHHapticEvent] {
        var events: [CHHapticEvent] = []
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }
        return events
    }
    
    func createHapticEvents3() -> [CHHapticEvent] {
        let short1 = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0)
        let short2 = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0.2)
        let short3 = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0.4)
        let long1 = CHHapticEvent(eventType: .hapticContinuous, parameters: [], relativeTime: 0.6, duration: 0.5)
        let long2 = CHHapticEvent(eventType: .hapticContinuous, parameters: [], relativeTime: 1.2, duration: 0.5)
        let long3 = CHHapticEvent(eventType: .hapticContinuous, parameters: [], relativeTime: 1.8, duration: 0.5)
        let short4 = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 2.4)
        let short5 = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 2.6)
        let short6 = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 2.8)
        return [short1, short2, short3, long1, long2, long3, short4, short5, short6]
    }
}
