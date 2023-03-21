//
//  ContentView.swift
//  Animations
//
//  Created by David Ruiz on 21/02/23.
//

import SwiftUI

struct ContentView: View {
    @State private var animationAmount = 1.0
    @State private var animationAmount2 = 1.0
    @State private var animationAmount3 = 0.0
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    
    let letters = Array("Hello, SwiftUI")
    @State private var enabledL = false
    @State private var dragAmountL = CGSize.zero
    
    @State private var isShowingRed = false
    @State private var isShowingRed2 = true
    
    
    var body: some View {
        VStack{
            // Implicit animation
            Button("Tap me"){
                // animationAmount += 1.0
            }
            .padding(50)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(.red)
                    .scaleEffect(animationAmount)
                    .opacity(2 - animationAmount)
                    .animation(
                        .easeInOut(duration: 1)
                        .repeatForever(autoreverses: false),
                        value: animationAmount
                    )
            )
            .onAppear {
                animationAmount = 2
            }
            
            
            
            // Animation binding
            Stepper("Scale amount", value: $animationAmount2.animation(
                .easeInOut(duration: 1)
            ), in: 1...10)
            
            Button("Tap Me"){
                animationAmount2 += 1
            }
            .padding(50)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .scaleEffect(animationAmount2)
            
            
            // Explicit animation
            
            Button("Tap Me"){
                withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)){
                    animationAmount3 += 360
                }
            }
            .padding(50)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .rotation3DEffect(.degrees(animationAmount3), axis: (x: 1, y: 0, z: 1))
            
            
            
            // Animation stack
            Button("Tap Me"){
                enabled.toggle()
            }
            .frame(width: 80, height: 50)
            .background(enabled ? .blue : .red)
            .animation(.default, value: enabled)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
            .animation(.interpolatingSpring(stiffness: 10, damping: 1), value: enabled)
            
            
            // Animating Gestures
            LinearGradient(gradient: Gradient(colors: [.yellow, .orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(width: 250, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .offset(dragAmount)
                .gesture(
                    DragGesture()
                        .onChanged{ dragAmount = $0.translation }
                        .onEnded{ _ in
                            withAnimation{
                                dragAmount = .zero
                            }
                        }
                )
            //.animation(.spring(), value: dragAmount)
            HStack(spacing: 0){
                ForEach(0..<letters.count){ num in
                    Text(String(letters[num]))
                        .padding(5)
                        .font(.subheadline)
                        .background(enabledL ? .blue : .red)
                        .offset(dragAmountL)
                        .animation(.default.delay(Double(num) / 20), value: dragAmountL)
                    
                }
                .gesture(
                    DragGesture()
                        .onChanged{
                            dragAmountL = $0.translation
                        }
                        .onEnded{ _ in
                            dragAmountL = .zero
                            enabledL.toggle()
                        }
                )
                
               
                
            }
            
            // Hidding viewa with transitions
            VStack {
                Button("Tap Me") {
                    withAnimation {
                        isShowingRed.toggle()
                    }
                }
                
                if isShowingRed {
                    Rectangle()
                        .fill(.red)
                        .frame(width: 200, height: 200)
                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                }
                
                //Building custom transitions using ViewModifier
                ZStack {
                    Rectangle()
                        .fill(.blue)
                        .frame(width: 200, height: 200)
                    
                    if isShowingRed2 {
                        Rectangle()
                            .fill(.red)
                            .frame(width: 200, height: 200)
                            .transition(.pivot)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        isShowingRed2.toggle()
                    }
                }

            }
            
        }
        
    }
}

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
