//
//  DailyForecastViewModel.swift
//  WeatherClient
//
//  Created by Andi Cho on 8/25/19.
//  Copyright © 2019 Andi Cho. All rights reserved.
//

import UIKit

struct DailyForecastViewModel {
    let dayOfTheWeek: String
    let summary: String
    let high: Int
    let low: Int
    let precip: Double
    let wind: Double
    let image: UIImage?
    
    static func format(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}

extension DailyForecastViewModel {
    init?(dailyForecast: DailyDatum) {
        let date = Date(timeIntervalSince1970: TimeInterval(dailyForecast.time))
        dayOfTheWeek = DailyForecastViewModel.format(date)
        summary = String(dailyForecast.summary)
        high = Int(dailyForecast.temperatureHigh)
        low = Int(dailyForecast.temperatureLow)
        wind = Double(dailyForecast.windGust)
        precip = Double(dailyForecast.precipProbability)
        image = UIImage(named:dailyForecast.icon)
    }
}
