//
//  ContentView.swift
//  AnimatedConnectButton
//
//  Created by Neil Francis Hipona on 7/4/23.
//

import SwiftUI

struct ContentView: View {
    @State private var buttonColorToggle = false
    @State private var isConnecting = false
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            let centerPoint = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let boxSquare = geometry.size.width / 2
            
            bgBox(geometry: geometry,
                  centerPoint: centerPoint,
                  boxSquare: boxSquare,
                  color: .green)
            bgBoxLineBorder(geometry: geometry,
                            centerPoint: centerPoint,
                            boxSquare: boxSquare,
                            color: .gray)
            bgBoxLineBorderTriangle(geometry: geometry,
                                    centerPoint: centerPoint,
                                    boxSquare: boxSquare,
                                    color: .gray)
            bgBoxLineArrow(geometry: geometry,
                           centerPoint: centerPoint,
                           boxSquare: boxSquare,
                           color: .gray)
            
            VStack {
                Button("Connect") {
                    isConnecting = true
                    print("Connect triggered!")
                }
                .foregroundColor(buttonColorToggle ? .gray : .black)
                .onReceive(timer, perform: { _ in
                    if isConnecting {
                        withAnimation(.easeInOut(duration: 1)) {
                            buttonColorToggle.toggle()
                        }
                    }
                })
            }
            .frame(width: geometry.size.width,
                   height: geometry.size.height)
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
    }
    
    func bgBox(geometry: GeometryProxy,
               centerPoint: CGPoint,
               boxSquare: CGFloat,
               color: Color) -> some View {
        let boxHalfSquare = boxSquare / 2
        
        return Path { path in
            path.addLines([
                CGPoint(x: centerPoint.x, y: centerPoint.y - boxHalfSquare),
                CGPoint(x: centerPoint.x + boxHalfSquare, y: centerPoint.y),
                CGPoint(x: centerPoint.x, y: centerPoint.y + boxHalfSquare),
                CGPoint(x: centerPoint.x - boxHalfSquare, y: centerPoint.y)
            ])
        }
        .fill(color)
    }
    
    func bgBoxLineBorder(geometry: GeometryProxy,
                         centerPoint: CGPoint,
                         boxSquare: CGFloat,
                         color: Color,
                         lineSpacing: CGFloat = 25) -> some View {
        let boxHalfSquare = (boxSquare / 2) + lineSpacing
        let tolerance: CGFloat = 4
        
        return Path { path in
//            path.addLines([
//                CGPoint(x: centerPoint.x, y: centerPoint.y - boxHalfSquare),
//                CGPoint(x: centerPoint.x + boxHalfSquare, y: centerPoint.y),
//                CGPoint(x: centerPoint.x, y: centerPoint.y + boxHalfSquare),
//                CGPoint(x: centerPoint.x - boxHalfSquare, y: centerPoint.y),
//                CGPoint(x: centerPoint.x, y: centerPoint.y - boxHalfSquare)
//            ])
            
            // top right
            path.move(to: CGPoint(x: centerPoint.x + tolerance,
                                  y: centerPoint.y - boxHalfSquare + tolerance))
            path.addLines([
                CGPoint(x: centerPoint.x + tolerance,
                                      y: centerPoint.y - boxHalfSquare + tolerance),
                CGPoint(x: centerPoint.x + boxHalfSquare - tolerance, y: centerPoint.y - tolerance)
            ])
            
            // bottom right
            path.move(to: CGPoint(x: centerPoint.x + boxHalfSquare - tolerance,
                                  y: centerPoint.y - tolerance))
            path.addLines([
                CGPoint(x: centerPoint.x + boxHalfSquare - tolerance, y: centerPoint.y + tolerance),
                CGPoint(x: centerPoint.x + tolerance, y: centerPoint.y + boxHalfSquare - tolerance)
            ])
            
            // bottom left
            path.move(to: CGPoint(x: centerPoint.x - tolerance,
                                  y: centerPoint.y + boxHalfSquare - tolerance))
            path.addLines([
                CGPoint(x: centerPoint.x - tolerance, y: centerPoint.y + boxHalfSquare - tolerance),
                CGPoint(x: centerPoint.x - boxHalfSquare + tolerance, y: centerPoint.y + tolerance)
            ])
            
            // top left
            path.move(to: CGPoint(x: centerPoint.x - boxHalfSquare + tolerance,
                                  y: centerPoint.y - tolerance))
            path.addLines([
                CGPoint(x: centerPoint.x - boxHalfSquare + tolerance,
                                      y: centerPoint.y - tolerance),
                CGPoint(x: centerPoint.x - tolerance, y: centerPoint.y - boxHalfSquare + tolerance)
            ])
        }
        .stroke(lineWidth: 1)
    }
    
    func bgBoxLineBorderTriangle(geometry: GeometryProxy,
                                 centerPoint: CGPoint,
                                 boxSquare: CGFloat,
                                 color: Color,
                                 lineSpacing: CGFloat = 25,
                                 triangleSize: CGFloat = 20) -> some View {
        let boxHalfSquare = (boxSquare / 2) + lineSpacing
        let centerPointTop = CGPoint(x: centerPoint.x, y: centerPoint.y - boxHalfSquare)
        let centerPointRight = CGPoint(x: centerPoint.x + boxHalfSquare, y: centerPoint.y)
        let centerPointBot = CGPoint(x: centerPoint.x, y: centerPoint.y + boxHalfSquare)
        let centerPointLeft = CGPoint(x: centerPoint.x - boxHalfSquare, y: centerPoint.y)
        let triangleHalfSize = triangleSize / 2
        
        return Path { path in
            path.addLines([ // top
                CGPoint(x: centerPointTop.x - triangleHalfSize, y: centerPointTop.y - triangleHalfSize),
                CGPoint(x: centerPointTop.x + triangleHalfSize, y: centerPointTop.y - triangleHalfSize),
                CGPoint(x: centerPointTop.x, y: centerPointTop.y + triangleHalfSize),
                CGPoint(x: centerPointTop.x - triangleHalfSize, y: centerPointTop.y - triangleHalfSize)
            ])
            
            path.move(to: CGPoint(x: centerPointRight.x - triangleHalfSize, y: centerPointRight.y))
            path.addLines([ // right
                CGPoint(x: centerPointRight.x - triangleHalfSize, y: centerPointRight.y),
                CGPoint(x: centerPointRight.x + triangleHalfSize, y: centerPointRight.y - triangleHalfSize),
                CGPoint(x: centerPointRight.x + triangleHalfSize, y: centerPointRight.y + triangleHalfSize),
                CGPoint(x: centerPointRight.x - triangleHalfSize, y: centerPointRight.y)
            ])
            
            path.move(to: CGPoint(x: centerPointBot.x, y: centerPointBot.y - triangleHalfSize))
            path.addLines([ // bot
                CGPoint(x: centerPointBot.x, y: centerPointBot.y - triangleHalfSize),
                CGPoint(x: centerPointBot.x + triangleHalfSize, y: centerPointBot.y + triangleHalfSize),
                CGPoint(x: centerPointBot.x - triangleHalfSize, y: centerPointBot.y + triangleHalfSize),
                CGPoint(x: centerPointBot.x, y: centerPointBot.y - triangleHalfSize)
            ])
            
            
            path.move(to: CGPoint(x: centerPointLeft.x + triangleHalfSize, y: centerPointLeft.y))
            path.addLines([ // left
                CGPoint(x: centerPointLeft.x + triangleHalfSize, y: centerPointLeft.y),
                CGPoint(x: centerPointLeft.x - triangleHalfSize, y: centerPointLeft.y + triangleHalfSize),
                CGPoint(x: centerPointLeft.x - triangleHalfSize, y: centerPointLeft.y - triangleHalfSize),
                CGPoint(x: centerPointLeft.x + triangleHalfSize, y: centerPointLeft.y)
            ])
        }
        .stroke(lineWidth: 2)
    }
    
    func bgBoxLineArrow(geometry: GeometryProxy,
                        centerPoint: CGPoint,
                        boxSquare: CGFloat,
                        color: Color,
                        lineSpacing: CGFloat = 25) -> some View {
        let boxHalfSquare = (boxSquare / 2) + lineSpacing * 2
        let tolerance: CGFloat = (boxSquare / 2)
        let halfLineSpacing = lineSpacing / 2
        let lineLength = tolerance * 1.5
        
        return Path { path in
            // top right
            path.move(to: CGPoint(x: centerPoint.x + tolerance,
                                  y: centerPoint.y - boxHalfSquare + tolerance))
            path.addLines([
                CGPoint(x: centerPoint.x + tolerance,
                                      y: centerPoint.y - boxHalfSquare + tolerance),
                CGPoint(x: centerPoint.x + boxHalfSquare - tolerance, y: centerPoint.y - tolerance)
            ])
            
            path.move(to: CGPoint(x: centerPoint.x + tolerance - halfLineSpacing, y: centerPoint.y - tolerance + halfLineSpacing))
            path.addLines([
                CGPoint(x: centerPoint.x + tolerance - halfLineSpacing, y: centerPoint.y - tolerance + halfLineSpacing),
                CGPoint(x: centerPoint.x + lineLength, y: centerPoint.y - lineLength)
            ])
            
            // bottom right
            path.move(to: CGPoint(x: centerPoint.x + boxHalfSquare - tolerance, y: centerPoint.y + tolerance))
            path.addLines([
                CGPoint(x: centerPoint.x + boxHalfSquare - tolerance, y: centerPoint.y + tolerance),
                CGPoint(x: centerPoint.x + tolerance, y: centerPoint.y + boxHalfSquare - tolerance)
            ])
            
            path.move(to: CGPoint(x: centerPoint.x + tolerance - halfLineSpacing, y: centerPoint.y + tolerance - halfLineSpacing))
            
            path.addLines([
                CGPoint(x: centerPoint.x + tolerance - halfLineSpacing, y: centerPoint.y + tolerance - halfLineSpacing),
                CGPoint(x: centerPoint.x + lineLength, y: centerPoint.y + lineLength)
            ])
            
            // bottom left
            path.move(to: CGPoint(x: centerPoint.x - tolerance,
                                  y: centerPoint.y + boxHalfSquare - tolerance))
            path.addLines([
                CGPoint(x: centerPoint.x - tolerance, y: centerPoint.y + boxHalfSquare - tolerance),
                CGPoint(x: centerPoint.x - boxHalfSquare + tolerance, y: centerPoint.y + tolerance)
            ])
            
            path.move(to: CGPoint(x: centerPoint.x - tolerance + halfLineSpacing,
                                  y: centerPoint.y + tolerance - halfLineSpacing))
            path.addLines([
                CGPoint(x: centerPoint.x - tolerance + halfLineSpacing,
                                      y: centerPoint.y + tolerance - halfLineSpacing),
                CGPoint(x: centerPoint.x - lineLength,
                                      y: centerPoint.y + lineLength)
            ])
            
            // top left
            path.move(to: CGPoint(x: centerPoint.x - boxHalfSquare + tolerance,
                                  y: centerPoint.y - tolerance))
            path.addLines([
                CGPoint(x: centerPoint.x - boxHalfSquare + tolerance,
                                      y: centerPoint.y - tolerance),
                CGPoint(x: centerPoint.x - tolerance, y: centerPoint.y - boxHalfSquare + tolerance)
            ])
            
            path.move(to: CGPoint(x: centerPoint.x - tolerance + halfLineSpacing, y: centerPoint.y - tolerance + halfLineSpacing))
            path.addLines([
                CGPoint(x: centerPoint.x - tolerance + halfLineSpacing, y: centerPoint.y - tolerance + halfLineSpacing),
                CGPoint(x: centerPoint.x - lineLength, y: centerPoint.y - lineLength)
            ])
        }
        .stroke(lineWidth: 1)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
