//
//  WeatherViewModel.swift
//  Weather
//
//  Created by AppleLab on 04/05/2021.
//

import Foundation

class WeatherViewModel: ObservableObject {
    @Published private(set) var model: WeatherModel = WeatherModel(cities: ["London", "Paris", "Prague", "Tokyo", "New York", "Berlin", "Warsaw"])
    
    var records: Array<WeatherModel.WeatherRecord> {
        model.records
    }
    
    func refresh(record: WeatherModel.WeatherRecord) {
        model.refresh(record: record)
    }
}
