//
//  MatchInfoVC.swift
//  MyCricInfo
//

import UIKit

class MatchInfoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.navigationItem.title = "Match Info"
    }
}
