//
//  ContentView.swift
//  Weather
//
//  Created by AppleLab on 04/05/2021.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        //Dodanie scrollowania pionowego
        ScrollView(.vertical){
            VStack {
                ForEach(viewModel.records) {record in
                    WeatherRecordView(record: record, viewModel: viewModel)
                }
            }.padding()
        }
    }
}

struct WeatherRecordView: View {
    var record: WeatherModel.WeatherRecord
    var viewModel: WeatherViewModel
    
    @State var counter: Int = 0
    @State var paramText = Text("Click on City")
    @State var icon = Text("☀")
    
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
                icon.font(.system(size: iconSize))
                //wyrownanie pojedynczej komorki do lewej strony ramki
                VStack (alignment: .leading) {
                    //dodanie spacera w celu obnizenia nazwy miasta
                    Spacer()
                    
                    //wyrowananie nazwy miasta oraz parametru do lewej strony
                    //teksty zostaly odseparowane od siebie dzieki czemu nie ma juz efektu poruszajacej sie nazwy miasta w momencie zmiany wyswietlanego parametru
                    GeometryReader { geometry in
                        Text(record.cityName).font(.title3)
                            .onTapGesture {
                                paramText = refreshText(record: record, counter: counter)
                                if (counter == 3) {
                                    counter = 0
                                } else {
                                    counter+=1
                                }
                            }
                    }
                    GeometryReader { geometry in
                        paramText.font(.system(size: 0.4*geometry.size.height))
                    }
                }
                
                Text("🔄")
                    .font(.largeTitle)
                    .onTapGesture {
                        let tmpCounter = counter-1
                        if (tmpCounter < 0) {
                            viewModel.refresh(record: record, counter: 3)
                            paramText = refreshText(record: record, counter: 3)
                        } else {
                            viewModel.refresh(record: record, counter: tmpCounter)
                            paramText = refreshText(record: record, counter: tmpCounter)
                        }
                        
                    }
            }
        }.onAppear(perform: {
            paramText = refreshText(record: record, counter: counter)
            counter+=1
            icon = refreshIcon(record: record)
        }).frame(width: recordViewWidth, height: recordViewHeight)
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
        case "c":
            return Text("☀")
        case "lc":
            return Text("🌤")
        case "hc":
            return Text("☁️")
        case "s":
            return Text("🌦")
        case "lr":
            return Text("🌧")
        case "hr":
            return Text("🌧")
        case "t":
            return Text("⛈")
        case "h":
            return Text("🌧")
        case "sl":
            return Text("🌧")
        case "sn":
            return Text("🌨")
        default:
            return Text("☀")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WeatherViewModel())
    }
}

struct ContentView_Previews_2: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
