//
//  InterfaceController.swift
//  WeatherWheel WatchKit Extension
//
//  Created by jgoble52 on 9/23/16.
//  Copyright © 2016 tangital. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController, CLLocationManagerDelegate {
    
    @IBOutlet var wheelPickerView: WKInterfacePicker!
    
    let locationManager = CLLocationManager()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
    }
    
    override func willActivate() {
        super.willActivate()
        
        let dayForecast = DayForecast()
        let wheelView = WKWheelView()
        let pickerItems = wheelView.generatePickerSequence(dayForecast, size: contentFrame.size, hour: 10)
        wheelPickerView.setItems(pickerItems)
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations)
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print(error)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func onWheelPickerChanged(value: Int) {
        
        
    }
    
    
}
