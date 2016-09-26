//
//  Precipitation.swift
//  Pods
//
//  Created by Satyam Ghodasara on 12/20/15.
//
//

import Foundation

/**
    Types of precipitation.
*/
public enum Precipitation: String, CustomStringConvertible {
    /// Rainy.
    case Rain = "rain"
    
    /// Snowy.
    case Snow = "snow"
    
    /// Sleety, freezing rain, ice pellets, or wintery mix.
    case Sleet = "sleet"
    
    /// Haily.
    case Hail = "hail"
    
    /**
        Returns the `String` value of the enum variant.
     
        - returns: `String` value of the enum variant.
    */
    public var description: String {
        return rawValue
    }
}
