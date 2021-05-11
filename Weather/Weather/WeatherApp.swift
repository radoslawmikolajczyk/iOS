//
//  WeatherApp.swift
//  Weather
//
//  Created by AppleLab on 04/05/2021.
//

import SwiftUI

@main
struct WeatherApp: App {
    var viewModel = WeatherViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel:  viewModel)
        }
    }
}
