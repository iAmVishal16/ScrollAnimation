//
//  ContentView.swift
//  ScrollAnimation
//
//  Created by Vishal Paliwal on 19/08/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if #available(iOS 17.0, *) {
            ScrollListView1()
        } else {
            // Fallback on earlier versions
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
