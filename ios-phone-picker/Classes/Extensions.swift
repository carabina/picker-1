//
//  Helper.swift
//  Eko
//
//  Created by Manuel Vrhovac on 28/11/2016.
//  Copyright © 2016 Manuel Vrhovac. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

public typealias EKOAnchor = String

var lastTimeStamp = Date()

func now(){
    lastTimeStamp = Date()
    stamp()
}

func stamp(_ message: String = "") {
    let ms = Int(Date().timeIntervalSince(lastTimeStamp)*1000)
    print(message + " \(ms)ms")
    lastTimeStamp = Date()
}

var ekoUsingInterfaceBuilder: Bool {
    #if TARGET_INTERFACE_BUILDER
        return true
    #else
        return false
    #endif
}

var isSimulator: Bool {
    #if (arch(i386) || arch(x86_64)) && os(iOS)
        return true
    #else
        return false
    #endif
}

func backgroundThread(closure:@escaping ()->()) {
    DispatchQueue.global(qos: .background).async {
        closure()
        
        
    }
}

func randomBetween(_ d1: Double, until d2: Double) -> Double{
    let zeroToOne = Float(arc4random()) / Float(UINT32_MAX)
    return d1 + (d2-d1)*Double(zeroToOne)
}

func mainThread(closure:@escaping ()->()){
    DispatchQueue.main.async {
        closure()
    }
}

extension Array {
    var nextToLast: Element? {
        if self.count < 2 { return nil }
        return self[self.count-2]
    }
}

extension Array where Element:Equatable {
    func removingDuplicates() -> [Element] {
        var result = [Element]()
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
}

extension Bool {
    mutating func negate() {
        self = !self
    }
}



public func delay(_ seconds: Double, if condition: Bool = true, _ completion: @escaping () -> ()) {
    if condition == false { return }
    if seconds == 0.0 {
        completion()
        return
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        mainThread {
            completion()
        }
    }
}


public extension Dictionary {
    
    var toJson: String{
        let prettyJsonData = try! JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        let prettyPrintedJson = String(data: prettyJsonData, encoding: String.Encoding.utf8)!
        return prettyPrintedJson
    }  

}


extension String {
    
    
    
    
    
}

public extension Character {
    
    var isUpperCase: Bool {
        return String(self) == String(self).uppercased()
    }
}

public extension String {
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    var local: String {
        return self
    }

    func removing(_ stringsToRemove: String...) -> String{
        var new = ""+self
        for toRemove in stringsToRemove {
            new = new.replacingOccurrences(of: toRemove, with: "")
        }
        return new
    }
    
    func removing(_ stringsToRemove: [String]) -> String{
        var new = ""+self
        for toRemove in stringsToRemove {
            new = new.replacingOccurrences(of: toRemove, with: "")
        }
        return new
    }
    
    var jsonToDict: [String:Any]?{
        let data = self.data(using: String.Encoding.utf8)
        let json = try? JSONSerialization.jsonObject(with: data!, options: [])
        if json == nil {
            print("json serialisation failed!")
            print("string: _\(self)_")
        }
        let dict = json as? [String:Any]
        return dict
    }
    
    var convertPlistToDictionary: [String:Any]? {
        guard let data = self.data(using: String.Encoding.utf8, allowLossyConversion: true) else { return nil }
        let opt = PropertyListSerialization.ReadOptions(rawValue: 0)
        let converted = try? PropertyListSerialization.propertyList(from: data, options: opt, format: nil)
        return converted as? [String:Any]
    }
    
    var prettyJSON: String {
        
        let jsonData = self.data(using: String.Encoding.utf8)!
        let jsonObject = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
        let prettyJsonData = try! JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        let prettyPrintedJson = String(data: prettyJsonData, encoding: String.Encoding.utf8)!
        return prettyPrintedJson
        
    }
    
    var fixedJSON: String {
        var s = self
        s = s.replacingOccurrences(of: "\\\"", with: "\"")
        s = s.replacingOccurrences(of: "\"{", with: "{").replacingOccurrences(of: "\"{", with: "{")
        s = s.replacingOccurrences(of: "}\"", with: "}").replacingOccurrences(of: "}\"", with: "}")
        s = s.replacingOccurrences(of: "\\r", with: "")
        s = s.replacingOccurrences(of: "\",\"btn\":", with: "\"},\"btn\":")
        s = s.replacingOccurrences(of: "}\"", with: "}")
        return s
    }
    
    func from(_ s: Int, until: Int) -> String {
        return (self as NSString).substring(with: NSMakeRange(s, until-s)) as String
    }
    
    func from(_ s: Int) -> String {
        return (self as NSString).substring(from: s)
    }
    
    func until(_ s: Int) -> String {
        return (self as NSString).substring(to: s)
    }
    
    func startsWith(_ s: String) -> Bool {
        if self.characters.count < s.characters.count { return false }
        return s == self.from(0, until: s.characters.count)
    }
    
    func endsWith(_ s: String) -> Bool {
        if self.characters.count < s.characters.count { return false }
        return s == self.from(self.characters.count-s.characters.count, until: self.characters.count)
    }
    
    func from(_ s: String, include: Bool = false) -> String {
        if !self.contains(s) { return self }
        let ns = self as NSString
        var r = ns.range(of: s).location
        if r > Int.max { r = -1 }
        return self.from(r ==  -1 ? 0 : include ? r : r+s.length)
    }
    
    func until(_ s: String, include: Bool = false) -> String {
        if !self.contains(s) { return self }
        let ns = self as NSString
        let r = ns.range(of: s).location
        return self.until(r == -1 ? 0 : include ? r+s.length : r)
    }
    
    func from(_ s: String, until: String, include: Bool = false) -> String {
        if !self.contains(s) { return self }
        if !self.contains(until) { return self }
        return self.from(s, include: include).until(until, include: include)
    }
    
    var length: Int { return self.characters.count }
    
    
}



public extension CALayer {
    
    func removeShadow(){
        self.shadowColor = UIColor.clear.cgColor
        self.shadowOpacity = 0.0
        self.shadowRadius = 0.0
        self.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func addShadow(color: UIColor, opacity: CGFloat, radius: CGFloat, distance: CGFloat){
        
        //if isSimulator { return }
        
        self.shadowColor = color.cgColor
        self.shadowOpacity = Float(opacity)
        self.shadowRadius = radius
        self.shadowOffset = CGSize(width: 0, height: distance)
        self.masksToBounds = false
        
        let rect = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.shadowPath = UIBezierPath(rect: rect).cgPath
        self.shouldRasterize = true
        self.rasterizationScale = 1
        self.rasterizationScale = UIScreen.main.scale
    }
    
    func addLabelShadow(color: UIColor, opacity: CGFloat, radius: CGFloat, distance: CGFloat){
        
        //if isSimulator { return }
        
        self.shadowColor = color.cgColor
        self.shadowOpacity = Float(opacity)
        self.shadowRadius = radius
        self.shadowOffset = CGSize(width: 0, height: distance)
        self.masksToBounds = false
        /*
        let rect = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.shadowPath = UIBezierPath(rect: rect).cgPath
        self.shouldRasterize = true
        self.rasterizationScale = 1
        self.rasterizationScale = UIScreen.main.scale*/
    }
    
    
}



public extension Date {
    
    var getHour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    var getMinute: Int {
        return Calendar.current.component(.minute, from: self)
    }
    
    var getSecond: Int {
        return Calendar.current.component(.second, from: self)
    }
    
    
    var getDayOfMonth: Int {
        return Calendar.current.ordinality(of: .day, in: .month, for: self)!
    }
    
    var getDayOfWeek: Int {
        let wd = Calendar.current.component(.weekday, from: self)
        return wd == 1 ? 7 : wd-1
    }
    
    var getDayOfYear: Int {
        return Calendar.current.ordinality(of: .day, in: .year, for: self)!
    }
    
    var getMonth: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var getYear: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var getPureDate: Date {
        return Date.from(year: self.getYear, month: self.getMonth, day: self.getDayOfMonth)
    }
    
    var getSecondsInDay: Int {
        return self.getHour * 60 * 60 + self.getMinute * 60 + self.getSecond
    }
    
    var isWeekend: Bool {
        return self.getDayOfWeek > 5
    }
    
    var isWorkday: Bool {
        return self.getDayOfWeek <= 5
    }
    
    static func from(year: Int, month: Int, day: Int) -> Date {
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        let date = gregorianCalendar.date(from: dateComponents)!
        return date
    }

    var descriptionNice: String {
        let df = DateFormatter()
        let language = "en"
        df.locale = Locale(identifier: language)
        df.dateFormat = "dd/MM/YYYY - HH:mm:ss"
        return df.string(from: self)
    }
    
    var descriptionWordsDate: String {
        let today = Date()
        let language = "en"
        let tomorrow = today.addingOneDay
        if today.DDMMYYYY == self.DDMMYYYY {
            return "today".local//"Today"
        }
        if tomorrow.DDMMYYYY == self.DDMMYYYY {
            return "tomorrow".local
        }
        else {
            let df = DateFormatter()
            df.dateFormat = "EEEE, MMM d"
            df.locale = Locale(identifier: language)
            return df.string(from: self)
        }
    }
    
    
    static func from(DDMMYYYY s: String) -> Date {
        let offset = s.characters.count == 10 ? 1 : 0
        let day   = Int(s.from(0,          until: 2))
        let month = Int(s.from(2+offset,   until: 4+offset))
        let year  = Int(s.from(4+offset*2, until: 8+offset*2))
        return Date.from(year: year!, month: month!, day: day!)
    }
    
    static func from(YYYYMMDD s: String) -> Date {
        let offset = s.characters.count == 10 ? 1 : 0
        let year   = Int(s.from(0,          until: 4))
        let month = Int(s.from(4+offset,   until: 6+offset))
        let day  = Int(s.from(6+offset*2, until: 8+offset*2))
        return Date.from(year: year!, month: month!, day: day!)
    }
    
    static func from(DDMMYYYY s: String, HHMM s2: String) -> Date {
        let h = Double(s2.from(0, until: 2))!
        let m = Double(s2.from(3, until: 5))!
        return Date.from(DDMMYYYY: s).addingTimeInterval(h*3600.0+m*60.0)
    }
    
    static func dayOfWeek(fromDDMMYYYY s: String) -> Int {
        return Date.from(DDMMYYYY: s).getDayOfWeek
    }
    
    var DDMMYYYY: String {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/YYYY"
        return df.string(from: self)
    }
    
    var withoutHoursAndMinutes: Date {
        return Date.from(DDMMYYYY: self.DDMMYYYY)
    }
    
    var HHMM: String {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df.string(from: self)
    }
    
    var YYYYMMDDHHMMSS: String {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return df.string(from: self)
    }
    
    
    var addingOneDay: Date {
        return self.addingTimeInterval(60.0*60.0*24.0)
    }
    
    
    
    
}



public extension UIColor {
    
    static var htmlColors: [String:String] {
        return [ "clear": "#00000000", "transparent": "#00000000", "none": "#00000000", "invisible": "#00000000", "aliceblue": "#F0F8FFFF", "antiquewhite": "#FAEBD7FF", "aqua": "#00FFFFFF", "aquamarine": "#7FFFD4FF", "azure": "#F0FFFFFF", "beige": "#F5F5DCFF", "bisque": "#FFE4C4FF", "black": "#000000FF", "blanchedalmond": "#FFEBCDFF", "blue": "#0000FFFF", "blueviolet": "#8A2BE2FF", "brown": "#A52A2AFF", "burlywood": "#DEB887FF", "cadetblue": "#5F9EA0FF", "chartreuse": "#7FFF00FF", "chocolate": "#D2691EFF", "coral": "#FF7F50FF", "cornflowerblue": "#6495EDFF", "cornsilk": "#FFF8DCFF", "crimson": "#DC143CFF", "cyan": "#00FFFFFF", "darkblue": "#00008BFF", "darkcyan": "#008B8BFF", "darkgoldenrod": "#B8860BFF", "darkgray": "#A9A9A9FF", "darkgrey": "#A9A9A9FF", "darkgreen": "#006400FF", "darkkhaki": "#BDB76BFF", "darkmagenta": "#8B008BFF", "darkolivegreen": "#556B2FFF", "darkorange": "#FF8C00FF", "darkorchid": "#9932CCFF", "darkred": "#8B0000FF", "darksalmon": "#E9967AFF", "darkseagreen": "#8FBC8FFF", "darkslateblue": "#483D8BFF", "darkslategray": "#2F4F4FFF", "darkslategrey": "#2F4F4FFF", "darkturquoise": "#00CED1FF", "darkviolet": "#9400D3FF", "deeppink": "#FF1493FF", "deepskyblue": "#00BFFFFF", "dimgray": "#696969FF", "dimgrey": "#696969FF", "dodgerblue": "#1E90FFFF", "firebrick": "#B22222FF", "floralwhite": "#FFFAF0FF", "forestgreen": "#228B22FF", "fuchsia": "#FF00FFFF", "gainsboro": "#DCDCDCFF", "ghostwhite": "#F8F8FFFF", "gold": "#FFD700FF", "goldenrod": "#DAA520FF", "gray": "#808080FF", "grey": "#808080FF", "green": "#008000FF", "greenyellow": "#ADFF2FFF", "honeydew": "#F0FFF0FF", "hotpink": "#FF69B4FF", "indianred": "#CD5C5CFF", "indigo": "#4B0082FF", "ivory": "#FFFFF0FF", "khaki": "#F0E68CFF", "lavender": "#E6E6FAFF", "lavenderblush": "#FFF0F5FF", "lawngreen": "#7CFC00FF", "lemonchiffon": "#FFFACDFF", "lightblue": "#ADD8E6FF", "lightcoral": "#F08080FF", "lightcyan": "#E0FFFFFF", "lightgoldenrodyellow": "#FAFAD2FF", "lightgray": "#D3D3D3FF", "lightgrey": "#D3D3D3FF", "lightgreen": "#90EE90FF", "lightpink": "#FFB6C1FF", "lightsalmon": "#FFA07AFF", "lightseagreen": "#20B2AAFF", "lightskyblue": "#87CEFAFF", "lightslategray": "#778899FF", "lightslategrey": "#778899FF", "lightsteelblue": "#B0C4DEFF", "lightyellow": "#FFFFE0FF", "lime": "#00FF00FF", "limegreen": "#32CD32FF", "linen": "#FAF0E6FF", "magenta": "#FF00FFFF", "maroon": "#800000FF", "mediumaquamarine": "#66CDAAFF", "mediumblue": "#0000CDFF", "mediumorchid": "#BA55D3FF", "mediumpurple": "#9370D8FF", "mediumseagreen": "#3CB371FF", "mediumslateblue": "#7B68EEFF", "mediumspringgreen": "#00FA9AFF", "mediumturquoise": "#48D1CCFF", "mediumvioletred": "#C71585FF", "midnightblue": "#191970FF", "mintcream": "#F5FFFAFF", "mistyrose": "#FFE4E1FF", "moccasin": "#FFE4B5FF", "navajowhite": "#FFDEADFF", "navy": "#000080FF", "oldlace": "#FDF5E6FF", "olive": "#808000FF", "olivedrab": "#6B8E23FF", "orange": "#FFA500FF", "orangered": "#FF4500FF", "orchid": "#DA70D6FF", "palegoldenrod": "#EEE8AAFF", "palegreen": "#98FB98FF", "paleturquoise": "#AFEEEEFF", "palevioletred": "#D87093FF", "papayawhip": "#FFEFD5FF", "peachpuff": "#FFDAB9FF", "peru": "#CD853FFF", "pink": "#FFC0CBFF", "plum": "#DDA0DDFF", "powderblue": "#B0E0E6FF", "purple": "#800080FF", "rebeccapurple": "#663399FF", "red": "#FF0000FF", "rosybrown": "#BC8F8FFF", "royalblue": "#4169E1FF", "saddlebrown": "#8B4513FF", "salmon": "#FA8072FF", "sandybrown": "#F4A460FF", "seagreen": "#2E8B57FF", "seashell": "#FFF5EEFF", "sienna": "#A0522DFF", "silver": "#C0C0C0FF", "skyblue": "#87CEEBFF", "slateblue": "#6A5ACDFF", "slategray": "#708090FF", "slategrey": "#708090FF", "snow": "#FFFAFAFF", "springgreen": "#00FF7FFF", "steelblue": "#4682B4FF", "tan": "#D2B48CFF", "teal": "#008080FF", "thistle": "#D8BFD8FF", "tomato": "#FF6347FF", "turquoise": "#40E0D0FF", "violet": "#EE82EEFF", "wheat": "#F5DEB3FF", "white": "#FFFFFFFF", "whitesmoke": "#F5F5F5FF", "yellow": "#FFFF00FF", "yellowgreen": "#9ACD32FF" ]
    }
    
    var hexStringWithHash: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return "#"+String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
    
    func rgb() -> (red:Int, green:Int, blue:Int, alpha:Int)? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            
            return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
    
    var contrastingTextColor: UIColor {
        guard let rgb = self.rgb() else { return UIColor.gray }
        
        let c = 0.299*Double(rgb.red) + 0.587*Double(rgb.green) + 0.114*Double(rgb.blue)
        let a = 1.0 - c/255.0
        return a < 0.2 ? UIColor.black : UIColor.white
    }
    
    
    var darkerAndLighter: (lighter: UIColor, darker: UIColor){
        
        let hsb = self.hsba
        
        let direction: [CGFloat] = [
            0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1,
            1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1,
            1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1
        ] // 0 is normal
        let intensity: [CGFloat] = [
            0.7, 0.9, 0.8, 0.7, 0.5, 0.3, 0.2, 0.2, 0.7, 1.0, 1.2, 1.4,
            1.5, 1.3, 0.9, 0.8, 0.7, 0.6, 0.6, 0.6, 0.6, 0.7, 0.9, 1.1,
            1.3, 1.3, 0.8, 0.5, 0.5, 0.6, 0.6, 0.8, 0.6, 0.7, 0.8, 0.8
        ]
        let indexUsed = Int(((hsb.h*360.0 + 15.0) / 10.0))%36
        
        let bshiftdamper: [CGFloat] = [
            1.5, 1.2, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.5, // 0 1 ... 10 11
            1.5, 2.0, 1.2, 0.8, 1.0, 1.3, 1.0, 0.5, 0.5, 0.5, 0.8, 1.0, // 12 - 23
            1.5, 2.0, 1.5, 1.0, 1.0, 0.7, 0.8, 1.3, 0.7, 1.0, 1.0, 0.8, // 24 - 35
        ]
        // hue 30.0
        // + 15.0 = 45.0
        // / 30.0 = 1.5 -> 1
        
        // hue 29.0 -> 44.0 -> 1.46 -> 1
        // hue 14.0 -> 29.0 -> 0.98 -> 0
        // hue 359.0 -> 374.0 -> 12.46 -> 12 -> 0
        
        let inv: CGFloat = direction[indexUsed] == 0 ? 1.0 : -1.0 // invert hue shifting if needed
        let hshiftDamper: CGFloat = intensity[indexUsed]
        let hshift: CGFloat = inv*hshiftDamper*0.02
        let sshift: CGFloat = (hsb.s < 0.05 ? 0.0 : 1.0)*0.02 // don't saturate if not colorful (like grey)
        let bshift: CGFloat = bshiftdamper[indexUsed] * 0.01 // 1.4-1.4= 0.0   or 1.4-0.4 = 1.0
        //print("damp: \(hshiftDamper), invert: \(inv), indexUsed: \(indexUsed)")
        
        let d = UIColor(hue: hsb.h + hshift, saturation: hsb.s - sshift, brightness: hsb.b + bshift, alpha: hsb.a)
        let l = UIColor(hue: hsb.h - hshift, saturation: hsb.s + sshift, brightness: hsb.b - bshift, alpha: hsb.a)
        return (d, l)
    }
    
    class func with(htmlCode code: String) -> UIColor? {
        return code.contains("#") ? UIColor.with(hex: code) : UIColor.with(name: code)
    }
    
    class func with(hex: String) -> UIColor? {
        var hex = hex.replacingOccurrences(of: "#", with: "").uppercased()
        if hex.characters.count != 6 && hex.characters.count != 8 { return nil }
        if hex.characters.count == 6 { hex += "FF" }
        let hexint = UInt32.init(hex, radix: 16)!
        let red = CGFloat((hexint & 0xff000000) >> 24) / 255.0
        let green = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let blue = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let alpha = CGFloat((hexint & 0xff) >> 0) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    class func with(name: String) -> UIColor? {
        let hex = UIColor.htmlColors[name.lowercased().replacingOccurrences(of: " ", with: "")]
        return UIColor.with(hex: hex ?? "#FFFFFF")
    }
    
    
    func lighter(by percentage:CGFloat=30.0) -> UIColor {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage:CGFloat=30.0) -> UIColor {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage:CGFloat=30.0) -> UIColor {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        } else{
            return self
        }
    }
    
    var hue: CGFloat {
        var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)
        self.getHue(&(hsba.h), saturation: &(hsba.s), brightness: &(hsba.b), alpha: &(hsba.a))
        return hsba.h
    }
    
    var saturation: CGFloat {
        var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)
        self.getHue(&(hsba.h), saturation: &(hsba.s), brightness: &(hsba.b), alpha: &(hsba.a))
        return hsba.s
    }
    
    var brightness: CGFloat {
        var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)
        self.getHue(&(hsba.h), saturation: &(hsba.s), brightness: &(hsba.b), alpha: &(hsba.a))
        return hsba.b
    }
    
    var alpha: CGFloat {
        var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)
        self.getHue(&(hsba.h), saturation: &(hsba.s), brightness: &(hsba.b), alpha: &(hsba.a))
        return hsba.a
    }
    
    var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat){
        var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)
        self.getHue(&(hsba.h), saturation: &(hsba.s), brightness: &(hsba.b), alpha: &(hsba.a))
        return hsba
    }
    
    
}



extension UIView {
    
    var isShown: Bool { get { return !isHidden } set { isHidden = !newValue} }
    
    var allSubviews: [UIView]{
        if self.subviews.count == 0 { return [self] }
        if self is UIButton { return [self] }
        if self is UILabel { return [self] }
        var all: [UIView] = []
        for sv in self.subviews{
            all += sv.allSubviews
        }
        return all
    }
    
    
    func snapToSuperview(sides: [NSLayoutAttribute]? = nil, constants: [CGFloat] = []){
        self.snapTo(view: superview, sides: sides, constants: constants)
    }
    
    func snapTo(view: UIView? = nil, sides: [NSLayoutAttribute]? = nil, constants: [CGFloat] = []){
        guard let view = view ?? superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        let allowedAttributes: [NSLayoutAttribute] = [.leading, .trailing, .top, .bottom]
        let sides = sides ?? allowedAttributes
        var constants = constants.count == sides.count ? constants : nil
        for (index, atr) in sides.enumerated() where allowedAttributes.contains(atr){
            view.addConstraint(NSLayoutConstraint(item: self, attribute: atr, relatedBy: .equal, toItem: view, attribute: atr, multiplier: 1, constant: constants?[index] ?? 0))
        }
        view.layoutIfNeeded()
    }
    
    
    func recolorButtonElements(tintColor tint: UIColor? = nil){
        let t = tint ?? self.tintColor
        for view in self.allSubviews {
            if view is UIButton {
                let button = view as! UIButton
                if button.tintColor == UIColor.clear || button.tintColor == nil { continue }
                guard let image = button.currentBackgroundImage else { continue }
                let colored = image.withRenderingMode(.alwaysTemplate)
                button.setBackgroundImage(colored, for: .normal)
                button.tintColor = t
            }
        }
    }
    
    var copyView: UIView? {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as? UIView
    }
    
}

extension UIImageView {
    
    func recolorToTint(){
        guard let image = self.image else { return }
        let colored = image.withRenderingMode(.alwaysTemplate)
        self.image = colored
    }
}



