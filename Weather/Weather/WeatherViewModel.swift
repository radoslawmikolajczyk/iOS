//
//  WeatherViewModel.swift
//  Weather
//
//  Created by AppleLab on 04/05/2021.
//

import Foundation
import Combine
import CoreLocation
import MapKit

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    //@Published private(set) var model: WeatherModel = WeatherModel(cities: ["London", "Paris", "Prague", "Tokyo", "New York", "Berlin", "Warsaw", "Los Angeles", "Chicago"])
    @Published var woeId: String = ""
    @Published private(set) var model: WeatherModel = WeatherModel(cities: ["1","44418","615702","796597","638242","1118370","2459115","523920","2379574"])
    @Published var currLocation: CLLocation?
    @Published var currLocName: String
    private var cancellables: Set<AnyCancellable> = []
    private var fetcher: MetaWeatherFetcher
    private let locationManager: CLLocationManager
    private let locFetcher: LocationFetcher
    var records: Array<WeatherModel.WeatherRecord> {
        model.records
    }
    
    override init() {
        fetcher = MetaWeatherFetcher()
        locFetcher = LocationFetcher()
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        currLocName = "Cracow"
        super.init()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        for record in records {
            refresh(record: record, counter: 0)
        }
    }
    
    func refresh(record: WeatherModel.WeatherRecord, counter: Int) {
        fetchWeather(forId: record.woeId, counter: counter, record: record)
    }
    
    func refreshDescription(record: WeatherModel.WeatherRecord, counter: Int) {
        model.updateDescription(record: record, counter: counter)
    }
    
    func fetchWeather(forId woeId: String, counter: Int, record: WeatherModel.WeatherRecord) {
        let ind = records.firstIndex(where: {$0.id==record.id})
        if ind == 0 {
            locFetcher.forecast(forId: currLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 50, longitude: 20))
                .sink(receiveCompletion: {_ in }, receiveValue: { locationValue in
                            self.fetcher.forecast(forId: String(locationValue[0].woeid))
                                .sink(receiveCompletion: {_ in}, receiveValue: {
                                    [self]value in
                                    self.model.refreshFromApi(woeId: record.woeId, counter: counter, response: value, locName: currLocName)
                                }).store(in: &self.cancellables)
                }).store(in: &cancellables)
        } else {
            fetcher.forecast(forId: woeId)
                .sink(receiveCompletion: {_ in}, receiveValue: { [self]value in
                    self.model.refreshFromApi(woeId: woeId, counter: counter, response: value, locName: "")
                }).store(in: &cancellables)
        }
    }
    
    
}
