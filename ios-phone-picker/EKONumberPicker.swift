//
//  EKONumberPicker.swift
//  Eko
//
//  Created by Manuel Vrhovac on 28/09/2017.
//  Copyright © 2017 Eko. All rights reserved.
//

import UIKit

class EKONumberPicker: NSObject, UITextFieldDelegate {
    
    var alert: UIAlertController!
    var tf: UITextField!
    var controller: UIViewController!
    var existingNumber: String? = nil
    var completion: ((String?)->())!
    var countryButton = UIButton(type: .system)
    var language = "en"
    
    func show(existingNumber: String?, controller: UIViewController, error: Bool = false, completion: @escaping (String?)->()){
        
        self.completion = completion
        self.existingNumber = existingNumber?.replacingOccurrences(of: " ", with: "")
        self.controller = controller
        self.alert = UIAlertController(
            title: error ? "error".local.capitalized : "phone-number".local,
            message: "type-phone".local,
            preferredStyle: .alert
        )
        
        let alert = self.alert!
        
        alert.addTextField(configurationHandler: {tf in
            self.tf = tf
            tf.delegate = self
            tf.placeholder = "555727100"
            tf.clearButtonMode = .whileEditing
            tf.keyboardType = .numberPad
            tf.font = UIFont.systemFont(ofSize: 15)
        })
        
        self.countryButton.contentHorizontalAlignment = .left
        self.countryButton.addTarget(self, action: #selector(changeCountry), for: .touchDown)
        self.countryButton.titleLabel?.lineBreakMode = .byClipping
        self.tf.leftView = countryButton
        self.tf.leftViewMode = .always
        var code = language
        var ext = EKOCountryPicker.countryCodes[code]
        if ext == nil { code = "es" ; ext = 34 }
        self.refreshCountryButton(code: code, ext: ext!)
        
        let cancel = UIAlertAction(title: "cancel".local, style: .cancel, handler: { v in
            alert.view.alpha = 0.5
            alert.dismiss(animated: true, completion: {})
            completion(nil)
        })
        let ok = UIAlertAction(title: "OK", style: .default, handler: { v in
            var input = alert.textFields!.first!.text!
            alert.dismiss(animated: true, completion: {})
            let allowed = [" ", "/", "(", ")", "-"]
            allowed.forEach{ input = input.removing($0) } // ignore this allowed characters
            let numSet = CharacterSet.decimalDigits.inverted
            var pureNumber = input.components(separatedBy: numSet).joined()
            if input != pureNumber || pureNumber.length < 5 {
                // user used other characters like letters or punctuation
                // replay the popup:
                self.show(existingNumber: existingNumber, controller: controller, error: true, completion: completion)
                return
            }
            if pureNumber.first == "0" { pureNumber.removeFirst() }
            let full = "+"+self.countryButton.title(for: .normal)!.from("+") + " " + pureNumber
            completion(full)
        })
            
        alert.addAction(cancel)
        alert.addAction(ok)
        alert.preferredAction = ok
        
        if let number = existingNumber {
            let ext = EKOCountryPicker.getExt(forNumber: number) ?? 34
            let code = EKOCountryPicker.getCode(forExtension: ext) ?? "es"
            refreshCountryButton(code: code, ext: ext)
            self.tf.text = number.from("+\(ext)")
        }
        
        controller.present(alert, animated: true, completion: nil)
        return
    }
    
    func refreshCountryButton(code: String, ext: Int){
        let l = String(ext).length
        let w = l > 2 ? 68 : l > 1 ? 58 : 48
        self.countryButton.frame = CGRect(x: 18, y: 94, width: w, height: 28)
        let flag = EKOCountryPicker.emojiFlag(countryCode: code)
        countryButton.setTitle(flag+" +\(ext)", for: .normal)
    }
    
    @objc func changeCountry(){
        self.alert.dismiss(animated: true, completion: {
            let cp = EKOCountryPicker()
            cp.show(controller: self.controller, handler: {
                code, extensionNumber in
                if extensionNumber != 0 { self.refreshCountryButton(code: code, ext: extensionNumber) }
                self.controller.present(self.alert, animated: true, completion: nil)
            })
        })
    }
}
