//
//  CommonMethods.swift
//

import AVFoundation
import UIKit
import CoreLocation
import Photos

func createUserDefault(key:String,data:Any) {
    let userDefaultObj = UserDefaults.standard
    userDefaultObj.set(data, forKey: key)
    userDefaultObj.synchronize()
}
func getUserdefaultDataForKey(Key:String) -> Any? {
    let userDefaultObj = UserDefaults.standard
    return userDefaultObj.value(forKey: Key)
}

func getCacheDir() -> NSString {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
    return paths[0] as NSString
}

func getFileURL() -> NSURL {
    let path = getCacheDir().appendingPathComponent("audio_file.m4a")
    let filePath = NSURL(fileURLWithPath: path)
    return filePath
}



func convertStringToDictionary(json: String) -> [String: AnyObject]? {
    if let data = json.data(using: String.Encoding.utf8) {
        
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject]
            return json
        } catch {
            
        }
    }
    return nil
}

func convertStringToArray(json: String) -> [AnyObject]? {
    if let data = json.data(using: String.Encoding.utf8) {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [AnyObject]
            return json
        } catch {
            
        }
    }
    return nil
}

func convertDictionaryToString(json: Any) -> String? {
    if let theJSONData = try? JSONSerialization.data(
        withJSONObject: json,
        options: []) {
        let theJSONText = String(data: theJSONData,
                                 encoding: .ascii)
        return theJSONText!
    }
    return nil
}
func convertDateStringDynamic(dateString:String,inputDateFormat : String ,outputDateFormat:String = "") -> String {
    if dateString.isEmpty {
        return ""
    }
    let dateFormatter = DateFormatter()
    let tempLocale = dateFormatter.locale // save locale temporarily
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX en_US_POSIX
    dateFormatter.dateFormat = inputDateFormat
    guard let date = dateFormatter.date(from: dateString) else {
        return "-"
    }
    dateFormatter.dateFormat = outputDateFormat.isEmpty ? "yyyy-MM-dd" : outputDateFormat
    dateFormatter.locale = tempLocale // reset the locale
    let dateStr = dateFormatter.string(from: date)
    return dateStr
}
func backButtonForNavBar() -> UIBarButtonItem {
    let backItem = UIBarButtonItem()
    backItem.title = " "
    return backItem
}
extension UIViewController {
    func alert(title: String,message: String ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
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
