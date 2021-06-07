//
//  LocationFetcher.swift
//  Weather
//
//  Created by Radek on 17/03/1400 AP.
//

import Foundation
import Combine
import CoreLocation

class LocationFetcher {
    func forecast(forId coords: CLLocationCoordinate2D) -> AnyPublisher<LocationResponse, Error> {
        return URLSession.shared.dataTaskPublisher(for: URL(string: "https://www.metaweather.com/api/location/search/?lattlong=\(coords.latitude),\(coords.longitude)")!)
            .map{$0.data}
            .decode(type: LocationResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
