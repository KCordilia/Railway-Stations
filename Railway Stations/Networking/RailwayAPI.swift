//
//  RailwayAPI.swift
//  Railway Stations
//
//  Created by Karim Cordilia on 05/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import Foundation

struct ServerPayload: Codable {
    let payload: [ServerStation]
}

struct ServerStation: Codable {
    let namen: ServerStationNames
    let stationType: String
    let lat: Double?
    let lng: Double?
}

struct ServerStationNames: Codable {
    let lang: String
}

struct RailwayServerNetworking {
    static func getAPIData(completion: @escaping (Data) -> Void) {
        guard
            let url = URL(string: "https://gateway.apiportal.ns.nl/public-reisinformatie/api/v2/stations")
            else { return }
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.addValue("f8cc8b29c7cf4edda4278772a25426be", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard
                let data = data
                else { return }
            completion(data)
        }
        task.resume()
    }
    
    static func loadRailwayData(completion: @escaping (ServerPayload) -> Void) {
        getAPIData { resultData in
            do {
                let decoder = JSONDecoder()
                let decodedResult = try decoder.decode(ServerPayload.self, from: resultData)
                completion(decodedResult)
            } catch let error {
                print(error)
            }
        }
    }
}


