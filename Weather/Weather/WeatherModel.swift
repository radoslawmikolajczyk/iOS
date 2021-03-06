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
            records.append(WeatherRecord(woeId: city))
        }
    }
    
    struct WeatherRecord: Identifiable, Equatable{
        var id: UUID = UUID()
        var cityName: String = "City"
        var weatherState: String = "Clear"
        var temperature: Float = Float.random(in: -10.0 ... 30)
        var humidity: Float = Float.random(in: 0 ... 100)
        var windSpeed: Float = Float.random(in: 0 ... 20)
        var windDirection: Float = Float.random(in: 0 ..< 360)
        var description: String = "Loading data..."
        var lat: Double = 50 
        var long: Double = 20
        var woeId: String
        //Do dodania w navigation view
        var airPressure: Double = 1025.0
        var predictability: Double = 50.0
        var visibility: Double = 14.0
        var applicableDate: String = "2021-06-09"
        var minTemp: Double = 14.2
        var maxTemp: Double = 20.0
        var windDirectionCompass: String = "W"
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
    
    mutating func updateDescription(record: WeatherRecord, counter: Int) {
        let ind = records.firstIndex(where: {$0.id==record.id})
        let descr = ["Temperature: \(records[ind!].temperature)???", "Humidity: \(records[ind!].humidity)%", "Wind Speed: \(records[ind!].windSpeed) km/h"]
        records[ind!].description = descr[counter]
    }
    
    mutating func refreshFromApi(woeId: String, counter: Int, response: MetaWeatherResponse, locName: String) {
        let ind = records.firstIndex(where: {$0.woeId==woeId})
        let location = response.lattLong.components(separatedBy: ",")
        
        if ind != 0 {
            records[ind!].cityName = response.title
        } else {
            records[ind!].cityName = "\(locName)(\(response.title))"
        }
        
        records[ind!].lat = Double(location[0])!
        records[ind!].long = Double(location[1])!
        records[ind!].weatherState = response.consolidatedWeather[0].weatherStateName
        records[ind!].temperature = round(Float(response.consolidatedWeather[0].theTemp)*10)/10
        records[ind!].humidity = round(Float(response.consolidatedWeather[0].humidity)*10)/10
        records[ind!].windSpeed = round(Float(response.consolidatedWeather[0].windSpeed)*10)/10
        let descr = ["Temperature: \(records[ind!].temperature)???", "Humidity: \(records[ind!].humidity)%", "Wind Speed: \(records[ind!].windSpeed) km/h"]
        records[ind!].description = descr[counter]
        records[ind!].airPressure = round(Double(response.consolidatedWeather[0].airPressure)*10)/10
        records[ind!].predictability = round(Double(response.consolidatedWeather[0].predictability)*10)/10
        records[ind!].visibility = round(Double(response.consolidatedWeather[0].visibility)*16.0934)/10
        records[ind!].applicableDate = response.consolidatedWeather[0].applicableDate
        records[ind!].minTemp = round(Double(response.consolidatedWeather[0].minTemp)*10)/10
        records[ind!].maxTemp = round(Double(response.consolidatedWeather[0].maxTemp)*10)/10
        records[ind!].windDirectionCompass = response.consolidatedWeather[0].windDirectionCompass
    }
}
