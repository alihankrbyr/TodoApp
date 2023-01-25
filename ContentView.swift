//
//  ContentView.swift
//  TodoApp
//
//  Created by Alihan Karabayır on 17.01.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        
        
        VStack {
            Image(systemName: "")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Home()
                .preferredColorScheme(.light)
            
                .font(.caption)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
