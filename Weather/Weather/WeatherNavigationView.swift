//
//  WeatherNavigationView.swift
//  Weather
//
//  Created by Radek on 19/03/1400 AP.
//

import SwiftUI
import CoreLocation
import MapKit

struct WeatherNavigationView: View {
    var record: WeatherModel.WeatherRecord
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.0, longitude: 20.0), span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta:1.0))
    
    var body: some View {
        VStack {
            HStack (alignment: .center){
                Text("\(record.cityName)").font(.system(size: 25))
                refreshIcon(record: record).font(.system(size: 70))
            }
            HStack (alignment: .center) {
                Text("Date: \(record.applicableDate)").font(.footnote)
            }
            Map(coordinateRegion: $region, annotationItems: [Loc(coord: .init(latitude: record.lat, longitude: record.long))]){
                place in MapPin(coordinate: place.coord)
            }
            .onAppear(perform: updateRegion)
            
            HStack (spacing:30) {
                Text("Min. temp.: \(record.minTemp, specifier: "%.1f") ℃").font(.subheadline)
                Text("Max. temp.: \(record.maxTemp, specifier: "%.1f") ℃").font(.subheadline)
            }
            Divider()
            VStack (spacing:10) {
                Text("Air Pressure: \(record.airPressure, specifier: "%.1f") hPa")
                Text("Visibility: \(record.visibility, specifier: "%.1f") km")
                Text("Wind Direction: \(record.windDirectionCompass)")
                Text("Predictability: \(record.predictability, specifier: "%.1f") %")
            }
        }
    }
    
    func updateRegion() {
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: record.lat, longitude: record.long), span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta:1.0))
    }
    
    func refreshIcon(record:WeatherModel.WeatherRecord) -> Text {
        switch (record.weatherState){
            case "Clear":
                return Text("☀")
            case "Light Cloud":
                return Text("🌤")
            case "Heavy Cloud":
                return Text("☁️")
            case "Showers":
                return Text("🌦")
            case "Light Rain":
                return Text("🌧")
            case "Heavy Rain":
                return Text("🌧")
            case "Thunderstorm":
                return Text("⛈")
            case "Hail":
                return Text("🌧")
            case "Sleet":
                return Text("🌧")
            case "Snow":
                return Text("🌨")
            default:
                return Text("☀")
        }
    }
}

struct WeatherNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherNavigationView(record: WeatherModel.WeatherRecord(woeId: "0"))
    }
}
