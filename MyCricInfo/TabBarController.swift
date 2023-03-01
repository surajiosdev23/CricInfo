//
//  TabBarController.swift
//  MyCricInfo

import UIKit

class TabBarController: UITabBarController {
    
    let layerGradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.tintColor = THEMECOLOR
        self.tabBar.unselectedItemTintColor = .lightGray
        
        let summaryVC : UIViewController = SummaryVC()
        let summaryNavVC = UINavigationController(rootViewController: summaryVC)
        summaryNavVC.title = "Summary"
        summaryNavVC.tabBarItem.image = UIImage(named: "summary")
        
        let scorecardVC : UIViewController = ScorecardVC()
        let scorecardNavVC = UINavigationController(rootViewController: scorecardVC)
        scorecardNavVC.title = "Scorecard"
        scorecardNavVC.tabBarItem.image = UIImage(named: "scorecard")
        
        
        let commentaryVC : UIViewController = CommentaryVC()
        let commentaryNavVC = UINavigationController(rootViewController: commentaryVC)
        commentaryNavVC.title = "Commentary"
        commentaryNavVC.tabBarItem.image = UIImage(named: "commentary")
        
        
        let matchInfoVC : UIViewController = MatchInfoVC()
        let matchInfoNavVC = UINavigationController(rootViewController: matchInfoVC)
        matchInfoNavVC.title = "Match Info"
        matchInfoNavVC.tabBarItem.image = UIImage(named: "matchinfo")
        
        self.viewControllers = [summaryNavVC,scorecardNavVC,commentaryNavVC,matchInfoNavVC]
    }
}
