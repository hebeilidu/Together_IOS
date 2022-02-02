//
//  TextView.swift
//  Together
//
//  Created by lcx on 2021/11/6.
//

import UIKit

class TextView: UITextView {
    var autocompleteTable: UITableView?
    var openMapButton: UIButton?
    
    var placeholder: String? {
        didSet {
            text = placeholder
        }
    }
    
    override var text: String! {
        didSet {
            textColor = text == placeholder ? .placeholderText : .label
        }
    }
    
    func loadSearchResults() {
        guard let table = autocompleteTable else { return }
        table.reloadData()
        if table.isHidden {
            UIView.animate(withDuration: 0.5) {
                table.isHidden = false
            }
        }        
    }
    
    func removeAutocompleteTable() {
        guard let table = autocompleteTable,
              let button = openMapButton
        else {
            return
        }
        UIView.animate(withDuration: 0.5) { [self] in
            table.isHidden = true
            button.isEnabled = hasText && text != placeholder ? true : false
        }
    }
}
