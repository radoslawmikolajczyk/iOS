//
//  LocationResponse.swift
//  Weather
//
//  Created by Radek on 17/03/1400 AP.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let locationResponse = try? newJSONDecoder().decode(LocationResponse.self, from: jsonData)

import Foundation

struct LocationResponses: Codable {
    let distance: Int
    let title: String
    let locationType: LocationType
    let woeid: Int
    let lattLong: String

    enum CodingKeys: String, CodingKey {
        case distance, title
        case locationType = "location_type"
        case woeid
        case lattLong = "latt_long"
    }
}

enum LocationType: String, Codable {
    case city = "City"
}

typealias LocationResponse = [LocationResponses]
