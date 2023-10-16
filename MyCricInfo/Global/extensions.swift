//
//  extensions.swift
//  MyCricInfo
//
//  Created by suraj jadhav on 14/10/23.
//

import UIKit

extension UIViewController {
    func alert(title: String,message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
extension UINavigationBar {
    func setUpNavBar(){
        let textAttributes = [NSAttributedString.Key.foregroundColor: THEMECOLOR]
        self.titleTextAttributes = textAttributes
        self.tintColor = THEMECOLOR
    }
}
