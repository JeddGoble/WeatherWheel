//
//  AppDelegate.swift
//  WeatherWheel
//
//  Created by jgoble52 on 9/23/16.
//  Copyright © 2016 tangital. All rights reserved.
//

import UIKit
import ForecastIO
import WatchConnectivity
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate, ForecastDelegate {
    
    let session = WCSession.defaultSession()
    var window: UIWindow?
    let forecastClient = ForecastClient()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setupWatchConnectivity()
        
        forecastClient.delegate = self
        
        return true
    }
    
    private func setupWatchConnectivity() {
        if WCSession.isSupported() {
            
            session.delegate = self
            session.activateSession()
        }
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        
        print("Message reached phone")
        
    }
    
    func didLoadWeather(hourlyTemperatures: [Hour]) {
        
        let dayForecast = DayForecast()
        dayForecast.hourlyForecast = hourlyTemperatures
        
        var hourlyDicts: [[String : Float]] = []
        
        for i in 0...23 {
            
            // TODO: Unwrap cleanly & check for nil
            
            let hourDict = ["temperature" : hourlyTemperatures[i].temperature!]
            hourlyDicts.append(hourDict)
            
        }
        
        
        let message = ["dayForecast" : hourlyDicts]
        session.sendMessage(message, replyHandler: { (reply) in
            
            }) { (error) in
                
        }
    }
    
    func requestLocationAuthorization(locationManager: CLLocationManager) {
        return
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

