//
//  ViewController.swift
//  WeatherWheel
//
//  Created by jgoble52 on 9/23/16.
//  Copyright © 2016 tangital. All rights reserved.
//

import UIKit
import ForecastIO
import CoreLocation

class ViewController: UIViewController, ForecastDelegate {
    
    @IBOutlet weak var wheelView: WheelView!
    
    var forecastClient: ForecastClient?
    
    var timer = NSTimer()
    
    var hourlyTemperatures: [Hour] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forecastClient = ForecastClient()
        forecastClient?.delegate = self
    }
    
    func requestLocationAuthorization(locationManager: CLLocationManager) {
        
        locationManager.requestAlwaysAuthorization()
    }
    
    func didLoadWeather(hourlyTemperatures: [Hour]) {
        
        wheelView.hourlyTemperatures = hourlyTemperatures
        
    }
}
