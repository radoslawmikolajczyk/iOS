//
//  WeatherModel.swift
//  Weather
//
//  Created by AppleLab on 04/05/2021.
//

import Foundation

struct WeatherModel {
    
    var records: Array<WeatherRecord> = []
    
    init(cities: Array<String>) {
        records = Array<WeatherRecord>()
        for city in cities {
            records.append(WeatherRecord(cityName: city))
        }
    }
    
    struct WeatherRecord: Identifiable, Equatable{
        var id: UUID = UUID()
        var cityName: String
        var weatherState: String = "lr"
        var temperature: Float = Float.random(in: -10.0 ... 30)
        var humidity: Float = Float.random(in: 0 ... 100)
        var windSpeed: Float = Float.random(in: 0 ... 20)
        var windDirection: Float = Float.random(in: 0 ..< 360)
    }
    
    mutating func refresh(record: WeatherRecord, counter: Int) {
        let index = records.firstIndex(of: record)
        switch (counter){
        case 0:
            records[index!].temperature = Float.random(in: -20.0 ... 40.0)
        case 1:
            records[index!].humidity = Float.random(in: 0 ... 100)
        case 2:
            records[index!].windSpeed = Float.random(in: 0 ... 20)
        case 3:
            records[index!].windDirection = Float.random(in: 0 ..< 360)
        default:
            print("Example")
        }
            
        print("Refreshing record: \(record)")
    }
}
