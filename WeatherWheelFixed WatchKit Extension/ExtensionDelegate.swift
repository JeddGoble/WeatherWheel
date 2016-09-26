//
//  ExtensionDelegate.swift
//  WeatherWheel WatchKit Extension
//
//  Created by jgoble52 on 9/23/16.
//  Copyright © 2016 tangital. All rights reserved.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
    
    let session = WCSession.defaultSession()
    
    func applicationDidFinishLaunching() {
        
        setupWatchConnectivity()
    }
    
    private func setupWatchConnectivity() {
        if WCSession.isSupported() {
            session.delegate = self
            session.activateSession()
            let message = ["request" : "requestDayForecast"]
            session.sendMessage(message, replyHandler: { (reply) in
                
                }, errorHandler: { (error) in
                    
            })
        } }
    
    func session(session: WCSession, activationDidCompleteWithState activationState: WCSessionActivationState, error: NSError?) {
        
        print(activationState)
        
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        
        if let hourlyForecast = message["dayForecast"] as? [[String : Float]] {
            
            if let screen = WKExtension.sharedExtension().rootInterfaceController as? InterfaceController {
                
                var dayForecast = DayForecast()
                dayForecast.hourlyForecast = []
                
                for hourDicts in hourlyForecast {
                    
                    if let temperature = hourDicts["temperature"] {
                        
                        let hour = Hour(temperature: temperature)
                        
                        dayForecast.hourlyForecast?.append(hour)
                        
                        
                    }
                }
                
                let wheelView = WKWheelView()
                let pickerItems = wheelView.generatePickerSequence(dayForecast, size: screen.contentFrame.size, hour: 10)
                
                screen.wheelPickerView.setItems(pickerItems)
            }
        }
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        
        if let hourlyForecast = applicationContext["dayForecast"] as? DayForecast {
            dispatch_async(dispatch_get_main_queue(), {
                WKInterfaceController.reloadRootControllersWithNames(["WheelViewController"], contexts: nil)
            })
        }
    }
    
    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
    
}
