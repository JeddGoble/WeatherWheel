//
//  ForecastClient.swift
//  WeatherWheel
//
//  Created by jgoble52 on 9/24/16.
//  Copyright © 2016 tangital. All rights reserved.
//

import Foundation
import ForecastIO
import CoreLocation

protocol ForecastDelegate {
    func didLoadWeather(hourlyTemperatures: [Hour])
    func requestLocationAuthorization(locationManager: CLLocationManager)
}

class ForecastClient: APIClient, CLLocationManagerDelegate {
    
    init() {
        super.init(apiKey: "48b868d6b01e36e3765f6e2660ee4b26")
        units = .Auto
        locationManager.delegate = self
        
    }
    
    var delegate: ForecastDelegate? {
        didSet {
            delegate?.requestLocationAuthorization(locationManager)
            startTimer()
            getWeather()
        }
    }
    
    let locationManager = CLLocationManager()
    var timer: NSTimer?
    
    var hourlyTemperatures: [Hour] = []
    
    func startTimer() {
        
        timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: #selector(getWeather), userInfo: nil, repeats: true)
    }
    
    func getWeather() {
        
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationManager.stopUpdatingLocation()
        
        guard let location = locations.first else {
            return
        }
        
        let coordinate = location.coordinate
        
        getForecast(latitude: coordinate.latitude, longitude: coordinate.longitude) { (forecast, error) in
            
            self.parseWeather(forecast)
            
        }
    }
    
    func parseWeather(forecast: Forecast?) {
        
        guard let forecast = forecast, let dataBlock = forecast.hourly, let hourly = dataBlock.data else {
            print("ForecastIO was unable to retrieve hourly forecast. :(")
            return
        }
        
        hourlyTemperatures = []
        
        for hour in hourly {
            
            guard let temperature = hour.temperature else {
                continue
            }
            
            let hour = Hour(temperature: temperature)
            hourlyTemperatures.append(hour)
        }
        
        delegate?.didLoadWeather(hourlyTemperatures)
    }
    
}


