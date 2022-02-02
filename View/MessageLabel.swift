//
//  MessageLabel.swift
//  Together
//
//  Created by lcx on 2021/11/12.
//

import UIKit

class MessageLabel: UILabel {
    private func showMessage(_ text: String, _ color: UIColor, _ timeInterval: TimeInterval) {
        DispatchQueue.main.async {
            self.backgroundColor = color
            self.text = text
            UIView.animate(withDuration: 0.3) {
                self.isHidden = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
                UIView.animate(withDuration: 0.3) {
                    self.isHidden = true
                }
            }
        }
    }
    
    func showSuccessMessage(_ message: String, timeInterval: TimeInterval = 2.0) {
        showMessage(message, .systemBlue, timeInterval)
    }
    
    func showFailureMessage(_ message: String, timeInterval: TimeInterval = 2.0) {
        showMessage(message, .systemRed, timeInterval)
    }
}
