//
//  Spinner.swift
//  Together
//
//  Created by lcx on 2021/11/19.
//

import SwiftUI

struct Spinner: View {
    @State private var isAnimating = false
    @Binding var isPresented: Bool
    
    var body: some View {
        if isPresented {
            return AnyView(
                VStack {
                    Circle()
                        .trim(from: 0.75, to: 1.0)
                        .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50, alignment: .center)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(.linear(duration: 0.8).repeatForever(autoreverses: false))
                    Text("Please Wait...")
                        .padding(.top)
                        .foregroundColor(.white)
                        .font(.body)
                }
                .frame(width: 150, height: 150, alignment: .center)
                .background(Color("Loading"))
                .cornerRadius(30)
                .onAppear {
                    isAnimating = true
                }
                .onDisappear {
                    isAnimating = false
                }
                .zIndex(7)
            )
        } else {
            return AnyView(EmptyView())
        }
    }
}

struct Spinner_Previews: PreviewProvider {
    static var previews: some View {
        Spinner(isPresented: .constant(true))
    }
}
