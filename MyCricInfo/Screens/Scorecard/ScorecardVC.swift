//
//  ScorecardVC.swift
//  MyCricInfo
//

import UIKit

class ScorecardVC: UIViewController {
    
    @IBOutlet weak var ibTableView: UITableView!
    
    let matchesArray = ["India vs New Zealand","South Africa vs Pakistan"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Scorecard"
        self.navigationController?.navigationBar.setUpNavBar()
        ibTableView.tableFooterView = UIView()
        let dummyViewHeight = CGFloat(40) //MARK: to prevent overlapping of header and tableview cell content
        self.ibTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.ibTableView.bounds.size.width, height: dummyViewHeight))
        self.ibTableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.navigationItem.title = "Scorecard"
    }
}
//MARK: Tableview set up
extension ScorecardVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = matchesArray[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
}
extension ScorecardVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = TeamsVC(nibName: "TeamsVC", bundle: nil)
        vc.matchUrl = ApiUrls.baseApi + (indexPath.row == 0 ? ApiUrls.nzIndUrl : ApiUrls.saPakUrl)
        vc.navBarTitle = matchesArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "Matches"
        cell.textLabel?.textColor = .darkGray
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}


