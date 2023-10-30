//
//  CommonMethods.swift
//

import UIKit

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
func returnThemeColor()-> UIColor{
    // Define a dynamic color provider for label title color
    let themeColor: UIColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return .systemOrange // Return dark mode color
        } else {
            return .black // Return light mode color
        }
    }
    return themeColor
}
