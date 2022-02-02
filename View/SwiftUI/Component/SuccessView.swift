//
//  SuccessView.swift
//  Together
//
//  Created by lcx on 2021/11/29.
//

import SwiftUI

struct SuccessView: View {
    @Binding var isPresented: Bool
    var text: String
    
    var body: some View {
        if isPresented {
            return AnyView(
                VStack {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(.green)
                        .frame(width: 50, height: 50, alignment: .center)
                    Text(text)
                        .foregroundColor(.white)
                        .font(.body)
                        .padding(.top)
                }
                .frame(width: 150, height: 150, alignment: .center)
                .background(Color("Loading"))
                .cornerRadius(30)
                .zIndex(15)
            )
        } else {
            return AnyView(EmptyView())
        }
    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView(isPresented: .constant(true), text: "Success")
    }
}
