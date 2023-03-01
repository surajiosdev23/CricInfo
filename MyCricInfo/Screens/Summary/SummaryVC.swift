//
//  SummaryVC.swift
//  MyCricInfo
//

import UIKit

class SummaryVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.navigationItem.title = "Summary"
    }
}
