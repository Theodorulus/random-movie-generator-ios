//
//  ContentView.swift
//  random-movie-picker
//
//  Created by user217570 on 4/18/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            List {
                NavigationLink(destination: MovieView(movieOrTv: "movie")) {
                    Text("Movie").font(.headline)
                }
                
                NavigationLink(destination: MovieView(movieOrTv: "tv")) {
                    Text("TV Series").font(.headline)
                }
            }
            .navigationBarTitle("Watch something?", displayMode: .large)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
