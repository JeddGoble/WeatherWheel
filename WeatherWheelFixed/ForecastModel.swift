//
//  ForecastModel.swift
//  WeatherWheel
//
//  Created by jgoble52 on 9/26/16.
//  Copyright © 2016 tangital. All rights reserved.
//

import Foundation
import UIKit

public struct Hour {
    var temperature: Float?
}

class DayForecast {
    
    var hourlyForecast: [Hour]?
}