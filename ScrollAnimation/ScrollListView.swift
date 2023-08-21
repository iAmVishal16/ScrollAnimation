//
//  ScrollListView.swift
//  ShapeAnimation
//
//  Created by Vishal Paliwal on 18/08/23.
//

import Foundation
import SwiftUI

struct ScrollListView: View {
    
    @State private var offset = CGFloat.zero

    
    var body: some View {
        GeometryReader { main in
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 16) {
                        ForEach (Row.preview) { item in
                            
                            GeometryReader { sub in
                                item.color.opacity(0.8)
                                    .frame(height: 200, alignment: .center)
                                    .overlay {
                                        Text(item.title)
                                            .font(.title).bold()
                                            .foregroundColor(.white)
                                    }
                                    .cornerRadius(16)
                                    .padding(.horizontal)
                                    .scaleEffect(scale(main: main.frame(in: .global).minY, item: sub.frame(in: .global).minY), anchor: .top)
                                    .opacity(scale(main: main.frame(in: .global).minY, item: sub.frame(in: .global).minY))
                            }
                            .frame(height: 200)
                        }
                    }
                    .background(GeometryReader {
                        Color.clear.preference(key: ViewOffsetKey.self,
                                               value: -$0.frame(in: .named("scroll")).origin.y)
                    })
                    .onPreferenceChange(ViewOffsetKey.self)
                    {
                        print("offset >> \($0)")
                        offset = $0
                    }
                }
//                .scrollDisabled(true)
                .coordinateSpace(name: "scroll")
            }
        }
        .padding(.vertical)
    }
    
    func scale(main: CGFloat, item: CGFloat) -> CGFloat {
        
        withAnimation(Animation.easeInOut) {
            let scale = item / main
            
            print("scale: \(scale)")
            
            if scale > 1 {
                return 1
            } else {
                return scale < 0 ? 0 : scale
            }
        }
    }
}

struct Row: Identifiable {
    let id = UUID()
    let title: String
    let color: Color
    
    static let preview: [Row] = [
        Row(title: "Row 1", color: .red),
        Row(title: "Row 2", color: .blue),
        Row(title: "Row 3", color: .green),
        Row(title: "Row 4", color: .orange),
        Row(title: "Row 5", color: .pink),
        Row(title: "Row 6", color: .cyan),
        Row(title: "Row 7", color: .mint),
        Row(title: "Row 8", color: .indigo),
        Row(title: "Row 9", color: .black),
        Row(title: "Row 10", color: .purple)

    ]
}
        
struct ScrollListView_Preview: PreviewProvider {
    static var previews: some View {
        ScrollListView()
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct PushCardsView: View {
    @State private var scrollOffset: CGFloat = 0

        var body: some View {
            NavigationView {
                GeometryReader { geometry in
                    List(0..<20, id: \.self) { index in
                        let cardOffset = CGFloat(index) * 150 - scrollOffset
                        let scaleFactor = max(1 - (cardOffset / geometry.size.width), 0.7)
                        let translation = cardOffset < 0 ? cardOffset : 0

                        CardView(title: "Card \(index + 1)", color: Color.red)
                            .scaleEffect(CGSize(width: scaleFactor, height: scaleFactor))
                            .offset(x: translation)
                            .frame(height: 150)
                    }
                    .onAppear {
                        UITableView.appearance().separatorStyle = .none
                    }
                    .background(
                        GeometryReader { innerGeometry in
                            Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: innerGeometry.frame(in: .named("scrollView")).minY)
                        }
                        .frame(height: 0)
                    )
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                        scrollOffset = offset
                    }
                }
                .navigationBarTitle("Stacking Cards")
            }
        }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct CardView: View {
    let title: String
    let color: Color

    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .padding()
        }
        .frame(maxWidth: .infinity)
        .background(color)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}


struct PushCardsView_Previews: PreviewProvider {
    static var previews: some View {
        PushCardsView()
    }
}

