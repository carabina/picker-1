//
//  CountryCodes.swift
//  Eko
//
//  Created by Manuel Vrhovac on 30/06/2017.
//  Copyright © 2017 Eko. All rights reserved.
//

import Foundation
import UIKit

class EKOCountryPicker: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var useAllCountries = true
    var popularCountriess = ["gr es fr hr it be cz dk de ee ie lt lu hu"]
    var allCountries = ["gr es fr hr it cy lv be bg cz dk de ee ie lt lu hu mt nl at pl pt ro si sk fi se gb is li no ch ru tr ae"]
    var picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
    
    
    func show(controller: UIViewController, handler: @escaping (String, Int)->()){
        
        picker.delegate = self
        picker.dataSource = self
        picker.reloadAllComponents()
        
        
        let segment = UISegmentedControl(items: ["quick".local, "show-all".local])
        segment.frame = CGRect(x: 0, y: 40, width: 200, height: 32)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(countryChanged), for: .valueChanged)
        
        let palert = UIAlertController(title: "select-country".local, message: " \n\n\n\n\n\n\n\n\n\n ", preferredStyle: .alert)
        palert.view.addSubview(picker)
        palert.view.addSubview(segment)
        
        segment.alpha = 0.0
        picker.alpha = 0.0
        
        func updateLayout(){
            segment.alpha = 1.0
            self.picker.alpha = 1.0
            self.picker.frame = CGRect(x: 0, y: 80, width: palert.view.frame.width, height: 150)
            segment.frame = CGRect(x: 20, y: 50, width: palert.view.frame.width-40, height: 32)
        }
        
        delay(0.1){
            updateLayout()
        }
        
        delay(0.3){
            updateLayout()
        }
        
        delay(1.0){
            updateLayout()
        }
        
        let choose = UIAlertAction(title: "choose".local, style: .default, handler: {
            action in
            let row = self.picker.selectedRow(inComponent: 0)
            let sel = !self.useAllCountries ? self.allCountries[row] : self.popularCountriess[row]
            let num = Int(sel.from("+").until("|")) ?? 1
            let code = sel.from("|")
            print("selected ", num, code)
            handler(code, num)
            palert.dismiss(animated: true, completion: {
            })
        })
        let cancel = UIAlertAction(title: "cancel".local, style: .cancel, handler: {
            action in
            handler("",0)
            palert.dismiss(animated: true, completion: {
            })
        })
        
        palert.addAction(choose)
        palert.addAction(cancel)
        palert.preferredAction = choose
        
        controller.present(palert, animated: true, completion: nil)
    }
    
    @objc func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (self.useAllCountries ? self.popularCountriess[row] : self.allCountries[row]).until("|")
    }
    
    @objc func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @objc func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let number = self.useAllCountries ? self.popularCountriess.count : self.allCountries.count
        print(number)
        return number
    }
    
    @objc func countryChanged(){
        self.useAllCountries = !self.useAllCountries
        self.picker.reloadAllComponents()
        self.picker.selectRow(0, inComponent: 0, animated: false)
    }
    
    static let countryCodes = [
        "lv":371,
        "lt":370,
        "np":977,
        "vn":84,
        "lr":231,
        "cf":236,
        "fi":358,
        "qa":974,
        "hk":852,
        "cg":242,
        "bz":501,
        "kp":850,
        "lb":961,
        "gn":224,
        "de":49,
        "uk":44,
        "er":291,
        "cm":237,
        "tv":688,
        "ly":218,
        "is":354,
        "az":994,
        "sz":268,
        "it":39,
        "tk":690,
        "dz":213,
        "si":386,
        "ug":256,
        "ye":967,
        "pm":508,
        "af":93,
        "sb":677,
        "yt":269,
        "bg":359,
        "cx":61,
        "om":968,
        "ga":241,
        "fo":298,
        "sn":221,
        "bw":267,
        "ca":1,
        "cc":61,
        "sa":966,
        "ve":58,
        "pg":675,
        "kw":965,
        "ad":376,
        "id":62,
        "ng":234,
        "sg":65,
        "by":375,
        "mp":670,
        "pk":92,
        "sv":503,
        "gp":590,
        "nc":687,
        "kz":7,
        "zw":263,
        "es":34,
        "fr":33,
        "st":239,
        "cv":238,
        "ls":266,
        "ki":686,
        "bo":591,
        "fk":500,
        "ar":54,
        "mg":261,
        "hr":385,
        "do":809,
        "ml":223,
        "km":269,
        "th":66,
        "wf":681,
        "ie":353,
        "il":972,
        "ae":971,
        "ua":380,
        "us":1,
        "la":856,
        "bd":880,
        "jo":962,
        "re":262,
        "be":32,
        "kr":82,
        "py":595,
        "an":599,
        "td":235,
        "rw":250,
        "bi":257,
        "tm":993,
        "mn":976,
        "va":39,
        "ba":387,
        "mc":377,
        "cz":420,
        "mt":356,
        "nr":674,
        "ws":684,
        "ph":63,
        "et":251,
        "mo":853,
        "pw":680,
        "pl":48,
        "na":264,
        "pf":689,
        "kh":855,
        "rs":381,
        "bf":226,
        "sy":963,
        "bn":673,
        "lk":94,
        "ir":98,
        "cd":243,
        "cl":56,
        "me":382,
        "sl":232,
        "au":61,
        "uy":598,
        "vu":678,
        "tr":90,
        "gt":502,
        "fm":691,
        "bt":975,
        "so":252,
        "cu":53,
        "to":676,
        "tn":216,
        "hu":36,
        "gh":233,
        "se":46,
        "ec":593,
        "sc":248,
        "cy":357,
        "nu":683,
        "aw":297,
        "mx":52,
        "gm":220,
        "ht":509,
        "al":355,
        "gl":299,
        "md":373,
        "as":684,
        "gi":350,
        "nz":64,
        "gb":44,
        "mr":222,
        "jp":81,
        "ni":505,
        "mz":258,
        "nf":672,
        "nl":31,
        "sh":290,
        "ch":41,
        "ee":372,
        "cn":86,
        "sd":249,
        "ci":225,
        "gr":30,
        "mk":389,
        "gw":245,
        "gq":240,
        "br":55,
        "cr":506,
        "mq":596,
        "aq":672,
        "za":27,
        "ro":40,
        "tj":992,
        "no":47,
        "pe":51,
        "bj":229,
        "dj":253,
        "ge":995,
        "my":60,
        "co":57,
        "ck":682,
        "at":43,
        "ma":212,
        "hn":504,
        "tz":255,
        "li":423,
        "sm":378,
        "sr":597,
        "mh":692,
        "mw":265,
        "zm":260,
        "gf":594,
        "mv":960,
        "ke":254,
        "ru":7,
        "am":374,
        "eg":20,
        "tg":228,
        "gy":592,
        "in":91,
        "mm":95,
        "bh":973,
        "ao":244,
        "kg":996,
        "fj":679,
        "pa":507,
        "uz":998,
        "lu":352,
        "iq":964,
        "dk":45,
        "ne":227,
        "tw":886,
        "sk":421,
        "mu":230,
        "pt":351
    ]
    
    static func getCountryCodeFor(numberWithPlus number: String) -> String {
        return ""
        /*let num = number.replacingOccurrences(of: "+", with: "")
        if num.length < 5 || Int(num) == nil {
            return ""
        }
        let ccs = Array(countryCodes.values.map{"+"+String($0)}.sorted().reversed())
        
        let fullNames = popularCountries(inLanguageIdentifier: "en")
        for name in fullNames{ print(name) }
        
        let array = countryCodes.sorted{$0.value > $1.value}
        var lastValue = 0
        var string = ""
        for tuple in array {
            if tuple.value == lastValue { string += " \(tuple.key)" }
            else { string += "\n\(tuple.value): \(tuple.key)"}
            lastValue = tuple.value
        }
        print(string)
        
        
        let countryNames = Dictionary(uniqueKeysWithValues: zip(countryCodes.map{$0.value}, countryCodes.map{$0.key}))
        for cc in ccs  where cc==num.until(cc.length){ return countryNames[Int(cc)!] ?? ""}
        return ""*/
    }
    
    static func getCode(forExtension ext: Int) -> String? {
        return countryCodes.filter{$0.value == ext}.first?.key
    }
    
    static func getExt(forNumber number: String) -> Int? {
        if number.length<4 || !number.startsWith("+"){ return 0 }
        let nums = countryCodes.map{$0.value}.sorted().reversed()
        for n in nums {
            if number.startsWith("+\(n)"){ return n }
        }
        return nil
    }
    
    static func popularCountries(inLanguageIdentifier lang: String = "en", withExtension: Bool = true, withEmojiFlag: Bool = true, all: Bool = false) -> [String]{
        let asiaPacific = "au cn hk jp kr my nz ph sg tw th "
        let americas = "br ca mx us "
        let euMiddleEast = "gr es fr hr it cy lv be bg cz dk de ee ie lt lu hu mt nl at pl pt ro si sk fi se gb is li no ch ru tr ae"
        var popular = Array(Set((asiaPacific+americas+euMiddleEast).components(separatedBy: " ")))
        if all { popular = Array(countryCodes.keys.sorted())}
        var fullNames = [String]()
        for code in popular {
            let twoLetter = code
            let name = (NSLocale(localeIdentifier: lang)).displayName(forKey: .countryCode, value: twoLetter)
            let extensionCode = withExtension ? " +\(countryCodes[twoLetter]!)" : ""
            let emoji = withEmojiFlag ? " "+emojiFlag(countryCode: twoLetter) : ""
            
            fullNames.append(name! + emoji + extensionCode + "|"+twoLetter)
        }
    
        return fullNames.sorted()
    }
    
    static func emojiFlag(countryCode: String) -> String {
        var string = ""
        var country = countryCode.uppercased()
        for uS in country.unicodeScalars {
            string += String(UnicodeScalar(127397 + uS.value)!)
        }
        return string
    }

}

