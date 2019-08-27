//
//  CurrentForecastViewModel.swift
//  WeatherClient
//
//  Created by Andi Cho on 8/25/19.
//  Copyright © 2019 Andi Cho. All rights reserved.
//

import UIKit

struct CurrentForecastViewModel {
    let time: Int
    let temp: Int
    let icon: UIImage
    let summary: String
    let wind: Double
    let precip: Double
}

extension CurrentForecastViewModel {
    init?(currentForecast: Currently) {
        time = Int(currentForecast.time)
        icon = UIImage(named:currentForecast.icon)!
        temp = Int(currentForecast.temperature)
        summary = String(currentForecast.summary)
        wind = Double(currentForecast.windGust)
        precip = Double(currentForecast.precipProbability)
    }
}
