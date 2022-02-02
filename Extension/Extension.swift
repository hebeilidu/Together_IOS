//
//  Extension.swift
//  Together
//
//  Created by lcx on 2021/11/10.
//

import Foundation
import UIKit
import Amplify

extension UILabel {
    func toInt() -> Int {
        guard let text = self.text,
              let num = Int(text)
        else {
            return 0
        }
        return num
    }
}

extension Optional where Wrapped == Temporal.DateTime {
    func toString() -> String {
        guard let date = self else { return "" }
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss a"
        return formatter.string(from: date.foundationDate)
    }
}

extension Transportation {
    public static func getInstance(of num: Int) -> Transportation {
        switch num {
        case 1:
            return .walk
        case 2:
            return .tram
        case 3:
            return .bike
        case 4:
            return .taxi
        default:
            return .car
        }
    }
    
    public static func getIntValue(of type: Transportation?) -> Int {
        guard let transportation = type else { return 0 }
        switch transportation {
        case .car:
            return 0
        case .walk:
            return 1
        case .tram:
            return 2
        case .bike:
            return 3
        case .taxi:
            return 4
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
