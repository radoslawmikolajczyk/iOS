//
//  WeatherViewModel.swift
//  Weather
//
//  Created by AppleLab on 04/05/2021.
//

import Foundation

class WeatherViewModel {
    private(set) var model: WeatherModel = WeatherModel()
    
    var records: Array<WeatherModel.WeatherRecord> {
        model.records
    }
    
    func refresh(record: WeatherModel.WeatherRecord) {
        model.refresh(record: record)
    }
}
