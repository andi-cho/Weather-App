//
//  ForecastViewController.swift
//  WeatherClient
//
//  Created by Andi Cho on 8/25/19.
//  Copyright © 2019 Andi Cho. All rights reserved.
//

import UIKit
import CoreLocation

class ForecastViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var windLabel: UILabel!
    @IBOutlet var precipLabel: UILabel!
    @IBOutlet var summaryIcon: UIImageView!
    @IBOutlet var currWindIcon: UIImageView!
    @IBOutlet var currRainIcon: UIImageView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var locationLabel: UILabel!
    
    let locationManager = LocationManager()
    
    var dailyViewModels: [DailyForecastViewModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var currentIcon: String! {
        didSet {
            summaryIcon.image = UIImage(named: currentIcon)
            summaryIcon.image = summaryIcon.image?.withRenderingMode(.alwaysTemplate)
            summaryIcon.tintColor = UIColor.white
        }
    }
    var currentTime: Int! {
        didSet {
            setBackgroundSkyImage(currentTime: TimeInterval(currentTime))
        }
    }
    var currentTemp: Double! {
        didSet {
            tempLabel.text = getTempLabel()
        }
    }
    var currentSummary: String! {
        didSet {
            summaryLabel.text = getSummaryLabel()
        }
    }
    var currentWind: Double! {
        didSet {
            windLabel.text = getWindSpeedLabel()
        }
    }
    var currentPrecip: Double!{
        didSet {
            precipLabel.text = getPrecipLabel()
        }
    }

    override func viewDidLoad() {
        // Set collection view delegate and data source
        collectionView.delegate = self
        collectionView.dataSource = self
        currWindIcon.image = currWindIcon.image?.withRenderingMode(.alwaysTemplate)
        currWindIcon.tintColor = UIColor.white
        currRainIcon.image = currRainIcon.image?.withRenderingMode(.alwaysTemplate)
        currRainIcon.tintColor = UIColor.white
        
        guard let exposedLocation = self.locationManager.exposedLocation else {
            print("*** Error in \(#function): exposedLocation is nil")
            return
        }
        // Get user's current location
    self.locationManager.getPlace(for: exposedLocation) { placemark in
            guard let placemark = placemark else { return }
            let country = placemark.country ?? "COUNTRY"
            let state = placemark.administrativeArea ?? "STATE"
            let town = placemark.locality
            self.locationLabel.text = town
            self.locationLabel.text?.append(", ")
            self.locationLabel.text?.append(state)
            self.locationLabel.text?.append(", ")
            self.locationLabel.text?.append(country)
        }
        super.viewDidLoad()
    }
    
    // MARK: - Collection view methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = 3
        return dailyViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseIdentifier", for: indexPath) as! DailyForecastCollectionViewCell
        
        // Configure cell
        let vm = dailyViewModels[indexPath.row]
        cell.forecastImageView.image = vm.image
        cell.forecastImageView.image = cell.forecastImageView.image?.withRenderingMode(.alwaysTemplate)
        cell.forecastImageView.tintColor = UIColor.white
        cell.temperatureLabel.text = "\(vm.low)-\(vm.high)ºF"
        cell.dayLabel.text = vm.dayOfTheWeek.uppercased()
        return cell
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    // MARK: - Helper functions
    
    // Set background image to morning, evening, or night sky depending on time.
        // Daytime = 6am - 4pm = hour 6 - 16
        // DEFAULT: Evening = 4pm - 8pm = hour 17 - 20
        // Night = 8pm - 6am = hour 21 - 24 or hour 1 - 5
    func setBackgroundSkyImage(currentTime: TimeInterval) {
        // Convert UNIX timeInterval to Date object and get hour
        let dateNow = Date(timeIntervalSince1970: TimeInterval(currentTime))
        let df = DateFormatter()
        df.locale = .current
        df.timeZone = .current
        df.dateFormat = "HH"
        let hour = Int(df.string(from: dateNow))!
        if (hour >= 6 && hour <= 16) {
            // Day time
            backgroundImageView.image = UIImage(named: "morningSky")
        } else if (hour >= 21 || hour < 6) {
            // Night time
            backgroundImageView.image = UIImage(named: "nightSky")
        }
        backgroundImageView.alpha = 0.8
    }
    
    // Gets current temperature (ex: "20º")
    func getTempLabel() -> String {
        return String(describing: Int((currentTemp!)))+"º"
    }
    
    // Gets current summary (ex: "Partly cloudy")
    func getSummaryLabel() -> String {
        return currentSummary
    }
    
    // Gets current wind speed (ex: "13 mph")
    func getWindSpeedLabel() -> String {
        return String(describing: Int(currentWind))+" mph"
    }
    
    // Gets current precipitation intensity (ex: 0%)
    func getPrecipLabel() -> String {
        return String(describing: Int(currentPrecip*100))+"%"
    }
}

// MARK: - Get Placemark
extension LocationManager {
    func getPlace(for location: CLLocation,
                  completion: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
}
