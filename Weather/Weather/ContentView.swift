//
//  ContentView.swift
//  Weather
//
//  Created by AppleLab on 04/05/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ForEach(0 ..< 7) {_ in
                WeatherRecordView()
            }
        }.padding()
    }
}

struct WeatherRecordView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0).stroke()
            HStack {
                Text("☀")
                    .font(.largeTitle)
                VStack {
                    Text("Kraków")
                    Text("Temperature: 27℃").font(.caption)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
