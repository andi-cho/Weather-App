//
//  DailyForecastCollectionViewCell.swift
//  WeatherClient
//
//  Created by Andi Cho on 8/26/19.
//  Copyright © 2019 Andi Cho. All rights reserved.
//

import UIKit
class DailyForecastCollectionViewCell: UICollectionViewCell {
    
    // MARK: Outlets
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var forecastImageView: UIImageView!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
