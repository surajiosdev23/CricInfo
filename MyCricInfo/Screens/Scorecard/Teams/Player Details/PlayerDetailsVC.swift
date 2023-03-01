//
//  PlayerDetailsVC.swift
//  MyCricInfo


import UIKit

class PlayerDetailsVC: UIViewController {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBattingStyle: UILabel!
    @IBOutlet weak var lblBowlingStyle: UILabel!
    @IBOutlet weak var lblRuns: UILabel!
    var playerModel : Player?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    func setUpUI(){
        self.title = "Player Info"
        self.navigationController?.navigationBar.setUpNavBar()
        lblName.text = playerModel?.nameFull
        lblBattingStyle.text = playerModel?.batting.style.rawValue.lowercased() == "rhb" ? "Right Hand Batter" : "Left Hand Batter"
        if playerModel?.bowling.style == ""{
            lblBowlingStyle.isHidden = true
        }else{
            lblBowlingStyle.isHidden = false
            var style = ""
            switch playerModel?.bowling.style.lowercased() {
            case "ob":
                style = "Off Break"
            case "lb":
                style = "Leg Break"
            case "lbg":
                style = "Leg Break Googly"
            case "slc":
                style = "Slow Left Arm Chinaman"
            case "slo":
                style = "Slow Left Arm Orthodox"
            case "rf":
                style = "Right Arm Fast"
            case "rfm":
                style = "Right Arm Fast Medium"
            case "rmf":
                style = "Right Arm Fast Medium"
            case "rm":
                style = "Right Arm Medium"
            case "lf":
                style = "Left Arm Fast"
            case "lfm":
                style = "Left Arm Fast Medium"
            case "lmf":
                style = "Left Arm Fast Medium"
            case "lm":
                style = "Left Arm Medium"
            default:
                style = playerModel?.bowling.style ?? "NA"
            }
            lblBowlingStyle.text = style + " Bowler"
        }
        
        lblRuns.text = "Runs : " + (playerModel?.batting.runs ?? "NA")
    }
}
