//
//  WKWheelView.swift
//  WeatherWheel
//
//  Created by jgoble52 on 9/25/16.
//  Copyright © 2016 tangital. All rights reserved.
//

import WatchKit

class WKWheelView: NSObject {
    
    var dayForecast: DayForecast? {
        didSet {
            print(self)
        }
    }
    
    func drawWheel(size: CGSize, hour: Int) {
        
        UIGraphicsBeginImageContext(size)
        
        let minSide = min(size.width, size.height)
        let originX = (size.width - minSide) / 2.0
        let originY = (size.height - minSide) / 2.0
        
        let wheelRect = CGRect(x: originX, y: originY, width: minSide, height: minSide)
        
        let circleOutline = UIBezierPath(ovalInRect: wheelRect)
        circleOutline.lineWidth = 2.0
        UIColor.whiteColor().setStroke()
        circleOutline.stroke()
        
        let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        
        let innerRadius = wheelRect.size.width / 10.0
        let outerRadius = wheelRect.size.width / 2.0
        
        
        for i in 0...23 {
            
            let colorLine = UIBezierPath()
            
            let counterToDegrees: (Int) -> (CGFloat) = { counter in return CGFloat(counter) * (360.0 / 24.0) }
            
            let startDegrees = counterToDegrees(i)
            let startRadians = startDegrees.degreesToRadians
            
            let lowerStartX = center.x + innerRadius * cos(startRadians)
            let lowerStartY = center.y + innerRadius * sin(startRadians)
            
            colorLine.moveToPoint(CGPoint(x: lowerStartX, y: lowerStartY))
            
            let upperStartX = center.x + outerRadius * cos(startRadians)
            let upperStartY = center.y + outerRadius * sin(startRadians)
            
            colorLine.addLineToPoint(CGPoint(x: upperStartX, y: upperStartY))
            
            let endDegrees = counterToDegrees(i + 1)
            let endRadians = endDegrees.degreesToRadians
            
            colorLine.addArcWithCenter(center, radius: outerRadius, startAngle: startRadians, endAngle: endRadians, clockwise: true)
            
            let lowerEndX = center.x + innerRadius * cos(endRadians)
            let lowerEndY = center.y + innerRadius * sin(endRadians)
            
            colorLine.addLineToPoint(CGPoint(x: lowerEndX, y: lowerEndY))
            
            colorLine.addArcWithCenter(center, radius: innerRadius, startAngle: endRadians, endAngle: startRadians, clockwise: false)
            
            if let dayForecast = dayForecast, let hourlyForecast = dayForecast.hourlyForecast where hourlyForecast.count > i {
                
                let temp = CGFloat(hourlyForecast[i].temperature!)
                temp.colorForTemperature().setFill()
            } else {
                
                UIColor.lightGrayColor().setFill()
            }
            
            colorLine.fill()
            
        }
        
    }
    
    func generatePickerSequence(forecast: DayForecast, size: CGSize, hour: Int) -> [WKPickerItem] {
        
        self.dayForecast = forecast
        
        var pickerItems: [WKPickerItem] = []
        
        for i in 0...23 {
            UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
            //        let context = UIGraphicsGetCurrentContext()
            
            drawWheel(size, hour: i)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let pickerItem = WKPickerItem()
            pickerItem.contentImage = WKImage(image: image)
            
            pickerItems.append(pickerItem)
            
        }
        
        return pickerItems
    }
}

extension Int {
    
    var degreesToRadians: CGFloat { return CGFloat(self - 90) * CGFloat(M_PI) / 180.0 }
}

extension CGFloat {
    
    var degreesToRadians: CGFloat { return (self - 90.0) * CGFloat(M_PI) / 180.0 }
}

extension CGFloat {
    
    func temperatureToColor() -> UIColor {
        
        var red, green, blue : CGFloat
        
        let percent = self / 100.0 // TODO: Switch with actual conversion
        
        red = (percent <= 66.0 ? 255.0 : (329.698 * pow(percent - 60, -0.1332))).clamp()
        green = (percent <= 66.0 ? (99.470 * log(percent) - 161.119) : 288.122 * pow(percent, -0.0755)).clamp()
        blue = (percent >= 66.0 ? 255.0 : (percent <= 19.0 ? 0 : 138.5177 * log(percent - 10.0) - 305.044)).clamp()
        
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
        
    }
    
    func clamp() -> CGFloat {
        
        return self > 255 ? 255 : (self < 0 ? 0 : self)
        
    }
    
    func colorForTemperature() -> UIColor {
        
        switch self {
        case 0...2:
            return UIColor(netHex: 0xECF0F1)
        case 2...4:
            return UIColor(netHex: 0xDCD2E5)
        case 4...6:
            return UIColor(netHex: 0xCCB4D9)
        case 6...8:
            return UIColor(netHex: 0xBB95CE)
        case 8...10:
            return UIColor(netHex: 0xAB77C2)
        case 10...12:
            return UIColor(netHex: 0x9B59B6)
        case 12...14:
            return UIColor(netHex: 0x8953A6)
        case 14...16:
            return UIColor(netHex: 0x774D96)
        case 16...18:
            return UIColor(netHex: 0x654685)
        case 20...22:
            return UIColor(netHex: 0x534075)
        case 22...24:
            return UIColor(netHex: 0x49406C)
        case 24...26:
            return UIColor(netHex: 0x403F63)
        case 26...28:
            return UIColor(netHex: 0x363F59)
        case 28...30:
            return UIColor(netHex: 0x2C3E50)
        case 30...32:
            return UIColor(netHex: 0x2B4D61)
        case 32...34:
            return UIColor(netHex: 0x2B5C73)
        case 34...36:
            return UIColor(netHex: 0x2A6B84)
        case 36...38:
            return UIColor(netHex: 0x2A7A96)
        case 38...40:
            return UIColor(netHex: 0x2989A7)
        case 40...42:
            return UIColor(netHex: 0x299099)
        case 42...44:
            return UIColor(netHex: 0x28988B)
        case 44...46:
            return UIColor(netHex: 0x289F7C)
        case 46...48:
            return UIColor(netHex: 0x27A76E)
        case 48...50:
            return UIColor(netHex: 0x27AE60)
        case 50...52:
            return UIColor(netHex: 0x4FB250)
        case 52...54:
            return UIColor(netHex: 0x78B740)
        case 54...56:
            return UIColor(netHex: 0xA0BB2F)
        case 56...58:
            return UIColor(netHex: 0xC9C01F)
        case 58...60:
            return UIColor(netHex: 0xF1C40F)
        case 60...62:
            return UIColor(netHex: 0xF1BC10)
        case 62...64:
            return UIColor(netHex: 0xF2B410)
        case 64...66:
            return UIColor(netHex: 0xF2AC11)
        case 66...68:
            return UIColor(netHex: 0xF3A411)
        case 68...70:
            return UIColor(netHex: 0xF39C12)
        case 70...72:
            return UIColor(netHex: 0xED8E0E)
        case 72...74:
            return UIColor(netHex: 0xE67F0B)
        case 74...76:
            return UIColor(netHex: 0xE07107)
        case 76...78:
            return UIColor(netHex: 0xD96204)
        case 78...80:
            return UIColor(netHex: 0xD35400)
        case 80...82:
            return UIColor(netHex: 0xCF4F09)
        case 82...84:
            return UIColor(netHex: 0xCB4911)
        case 84...86:
            return UIColor(netHex: 0xC8441A)
        case 86...88:
            return UIColor(netHex: 0xC43E22)
        case 88...90:
            return UIColor(netHex: 0xC0392B)
        case 90...92:
            return UIColor(netHex: 0xB13428)
        case 92...94:
            return UIColor(netHex: 0xA13024)
        case 94...96:
            return UIColor(netHex: 0x922B21)
        case 96...98:
            return UIColor(netHex: 0x82271D)
        case 98...100:
            return UIColor(netHex: 0x73221A)
        case 100...102:
            return UIColor(netHex: 0x651E17)
        case 102...104:
            return UIColor(netHex: 0x571A14)
        case 104...106:
            return UIColor(netHex: 0x4A1610)
        case 106...108:
            return UIColor(netHex: 0x3C120D)
        case 108...110:
            return UIColor(netHex: 0x2E0E0A)
            
        default:
            return UIColor.blackColor()
        }
        
        return UIColor.whiteColor()
    }
    
}
