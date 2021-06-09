//
//  ContentView.swift
//  Weather
//
//  Created by AppleLab on 04/05/2021.
//

import SwiftUI
import CoreLocation
import MapKit

struct ContentView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        //Dodanie scrollowania pionowego
        NavigationView {
            ScrollView(.vertical){
                VStack {
                    ForEach(viewModel.records) {record in
                        WeatherRecordView(record: record, viewModel: viewModel)
                    }
                }.padding()
            }.navigationBarHidden(true)
        }
    }
    
}

struct WeatherRecordView: View {
    var record: WeatherModel.WeatherRecord
    var viewModel: WeatherViewModel
    
    @State var counter: Int = 0
    @State var paramText = Text("Click on City")
    @State var icon = Text("☀")
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.0, longitude: 20.0), span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta:1.0))
    @State private var trackingMode = MapUserTrackingMode.none
    @State private var places: [Loc] = [Loc(coord: .init(latitude: 30.064528, longitude: 19.923556))]
    @State private var showingSheet = false
    
    
    private let recordViewWidth: CGFloat? = 300
    private let recordViewHeight: CGFloat? = 80
    private let cornerRadius: CGFloat = 25.0
    private let iconSize: CGFloat = 60
    
    var body: some View {
        ZStack {
            //ustalenie promienia na 25.0
            RoundedRectangle(cornerRadius: cornerRadius).stroke()
            HStack {
                //ustalenie wielkosci ikonki jako 60
                refreshIcon(record: record).font(.system(size: iconSize))
                //wyrownanie pojedynczej komorki do lewej strony ramki
                VStack (alignment: .leading) {
                    //dodanie spacera w celu obnizenia nazwy miasta
                    Spacer()
                    
                    //wyrowananie nazwy miasta oraz parametru do lewej strony
                    //teksty zostaly odseparowane od siebie dzieki czemu nie ma juz efektu poruszajacej sie nazwy miasta w momencie zmiany wyswietlanego parametru
                    GeometryReader { geometry in
                        Text(record.cityName).font(.subheadline)
                            .onTapGesture {
                                self.counter += 1
                                if self.counter > 2 {
                                    self.counter = 0
                                }
                                viewModel.refreshDescription(record: record, counter: self.counter)
                            }
                    }
                    GeometryReader { geometry in
                        Text(record.description).font(.system(size: 0.4*geometry.size.height))
                    }
                }
                
                Text("🔄")
                    .font(.title)
                    .onTapGesture {
                        if self.counter > 2 {
                            self.counter = 0
                        }
                        viewModel.refresh(record: record, counter: self.counter)
                    }
                Text("🗺")
                    .font(.title)
                    .onTapGesture {
                        updateRegion()
                        showingSheet = true
                    }
                    .frame(alignment: .trailing)
                    .sheet(isPresented: $showingSheet, content: {
                        VStack {
                            Text("\(record.cityName)")
                        }
                        Map(coordinateRegion: $region, annotationItems: [Loc(coord: .init(latitude: record.lat, longitude: record.long))]){
                            place in MapPin(coordinate: place.coord)
                        }
                        .onAppear(perform: updateRegion)
                    })
                NavigationLink(
                    destination: WeatherNavigationView(record: record),
                    label: {
                        Text(">")
                    })
            }
        }.frame(width: recordViewWidth, height: recordViewHeight)
        //ustalenie na sztywno parametrow komorki
    }
    
    func refreshText(record: WeatherModel.WeatherRecord, counter: Int) -> Text {
        switch (counter){
        case 0:
            return Text("Temperature: \(record.temperature, specifier: "%.1f")℃")
        case 1:
            return Text("Humidity: \(record.humidity, specifier: "%.1f")%")
        case 2:
            return Text("Wind Speed: \(record.windSpeed, specifier: "%.1f")km/h")
        case 3:
            return Text("Wind Direction: \(record.windDirection, specifier: "%.1f")º")
        default:
            return Text("DEFAULT")
        }
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
    
    func updateRegion() {
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: record.lat, longitude: record.long), span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta:1.0))
    }
}

struct Loc: Identifiable {
    let id = UUID()
    let coord: CLLocationCoordinate2D
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WeatherViewModel())
    }
}
