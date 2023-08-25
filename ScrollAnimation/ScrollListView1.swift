//
//  ScrollListView1.swift
//  ScrollAnimation
//
//  Created by Vishal Paliwal on 19/08/23.
//

//
//  ScrollListView.swift
//  ShapeAnimation
//
//  Created by Vishal Paliwal on 18/08/23.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)
struct ScrollListView1: View {
    
    @State private var offset = CGFloat.zero

    
    var body: some View {
        GeometryReader { main in
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 16) {
                        ForEach (Row.preview.indices, id: \.self) { index in
                            let item = Row.preview[index]
                            GeometryReader { sub in
                                item.color.opacity(0.8)
                                    .frame(height: 200, alignment: .center)
                                    .overlay {
                                        Text(item.title)
                                            .font(.title).bold()
                                            .foregroundColor(.white)
                                    }
                                    .cornerRadius(16)
//                                    .scrollTransition(transition: { effect, phase in
//                                        effect
//                                            .offset(y: offset(for: phase))
//                                            .scaleEffect(scale(for: phase), anchor: .top)
//                                    })
                                    .visualEffect { effect, proxy in
                                        // Adjust the scale range as needed
                                        
                                        effect
                                            .scaleEffect(max(1.0 - -min(0, proxy.frame(in: .global).minY) / 100, 0.9))
                                            .offset(y: -min(0, proxy.frame(in: .global).minY))
//                                            .brightness(max(1.0 - ((main.bounds.height - proxy.frame(in: .global).minY) / main.bounds.height) * 0.5, 0.5))

                                        
                                    }
                                    .padding(.horizontal)
                            }
                            .frame(height: 200)
                        }
                    }
                }
            }
        }
    }
    
    func offset(for phase: ScrollTransitionPhase) -> Double {
        
        
        switch phase {
        case .topLeading:
            400
        case .identity:
            0
        case .bottomTrailing:
            0
        }
        
    }

    func scale(for phase: ScrollTransitionPhase) -> Double {
        switch phase {
        case .topLeading:
            0.5
        case .identity:
            1
        case .bottomTrailing:
            1.0
        }
    }
}

        
@available(iOS 17.0, *)
struct ScrollListView1_Preview: PreviewProvider {
    static var previews: some View {
        ScrollListView1()
    }
}
