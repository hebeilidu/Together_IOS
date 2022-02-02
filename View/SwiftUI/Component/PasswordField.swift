//
//  PasswordField.swift
//  Together
//
//  Created by lcx on 2021/11/19.
//

import SwiftUI

struct PasswordField: View {
    let placeholder: String
    @Binding var text: String
    let switchCondition: () -> Bool
    
    var body: some View {
        HStack {
            SecureField(placeholder, text: $text)
            if !text.isEmpty {
                switchCondition() ?
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.green) :
                Image(systemName: "exclamationmark.circle")
                    .foregroundColor(.red)
            }
        }
    }
}

struct PasswordField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordField(placeholder: "Placeholder", text: .constant("Text"), switchCondition: { true })
            .previewLayout(.sizeThatFits)
    }
}
