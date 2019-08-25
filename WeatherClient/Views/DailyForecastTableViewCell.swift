//
//  DailyForecastTableViewCell.swift
//  WeatherClient
//
//  Created by Andi Cho on 8/24/19.
//  Copyright © 2019 Andi Cho. All rights reserved.
//

import UIKit

class DailyForecastTableViewCell: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var forecastImageView: UIImageView!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
