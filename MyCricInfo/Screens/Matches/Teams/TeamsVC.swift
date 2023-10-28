//MARK: Import Statements
import UIKit

//MARK: TeamsVC Class Definition
class TeamsVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var ibTableView: UITableView!
    @IBOutlet weak var ibCollectionView: UICollectionView!
    @IBOutlet weak var ibActivityIndicator: UIActivityIndicatorView!
    
    //MARK: Properties
    var dataModel : DataModel?
    let teamsVM = TeamsViewModel()
    var selectedTabIndex = 0 //MARK: for Tab switching reference
    var matchUrl = ""
    var matchInfo = ""
    
    //MARK: View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavigationBar()
        self.setUpTableview()
        self.fetchData()
    }
    func setUpNavigationBar(){
        self.title = "Squads"
        self.navigationController?.navigationBar.setUpNavBar()
        //MARK: Set right bar button item
        let showInfo = UIBarButtonItem(title: "Info", style: .plain, target: self, action: #selector(showInfoTapped(sender:)))
        navigationItem.rightBarButtonItems = [showInfo]
    }
    //MARK: UI Setup
    func setUpTableview(){
        // Set table view properties
        ibTableView.tableFooterView = UIView()
        ibCollectionView.register(UINib(nibName: "TeamTabCell", bundle: nil), forCellWithReuseIdentifier: "TeamTabCell")
        let dummyViewHeight = CGFloat(40) //MARK: to prevent overlapping of header and tableview cell content
        self.ibTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.ibTableView.bounds.size.width, height: dummyViewHeight))
        self.ibTableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
    }
    
    // Additional UI Setup and Helper Methods...
    
    //MARK: Show Info Button Action
    @objc func showInfoTapped(sender : UIBarButtonItem){
        self.alert(title: "Match Info", message: matchInfo)
    }
    
    //MARK: Activity Indicator Methods
    func activityIndicatorBegin() {
        ibActivityIndicator.hidesWhenStopped = true
        ibActivityIndicator.style = .medium
        ibActivityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    func activityIndicatorEnd() {
        self.ibActivityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
    }
    
    //MARK: Data Fetching
    func fetchData(){
        self.ibCollectionView.isHidden = true
        self.ibTableView.isHidden = true
        if isConnectedToNetwork(){
            self.ibActivityIndicator.startAnimating()
            teamsVM.fetchPlayerData(matchUrl: matchUrl, completion: { [weak self] response in
                self?.ibActivityIndicator.stopAnimating()
                switch response{
                case .success(let data):
                    debugPrint("success")
                    guard let data = data else {
                        return
                    }
                    self?.dataModel = data
                    self?.setData(data: data)
                case .failure(let err):
                    debugPrint("failure")
                    debugPrint("ERROR \(err)")
                    self?.alert(title: "Alert", message: err.localizedDescription)
                }
            })
        }else{
            self.alert(title: "Alert", message: "Connect to internet")
            self.ibCollectionView.isHidden = true
        }
    }
    
    //MARK: Additional Data Handling and Helper Methods...
    
    //MARK: Set Data
    func setData(data : DataModel){
        self.ibCollectionView.isHidden = false
        self.ibTableView.isHidden = false
        let time = data.matchdetail?.match?.time ?? ""
        let date = data.matchdetail?.match?.date ?? ""
        let dateConverted = convertDateStringDynamic(dateString: date, inputDateFormat: "MM/dd/yyyy",outputDateFormat: "EEEE, MMM d, yyyy")
        let venue = data.matchdetail?.venue?.name ?? ""
        DispatchQueue.main.async {
            self.matchInfo = dateConverted + ", " + time + "\n" + venue
            self.ibTableView.reloadData()
            self.ibCollectionView.reloadData()
        }
    }
}

//MARK: Tableview set up
extension TeamsVC : UITableViewDataSource{
    //MARK: Number of Rows in Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel?.teams?.values.first?.players?.count ?? 0
    }
    
    //MARK: Cell for Row at IndexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        //MARK: To sort players according to batting position
        var sortedArray = dataModel?.teams?.values.first?.players?.sorted(by: { a, b in
            (Int(a.value.position ?? "0") ?? 0) < (Int(b.value.position ?? "0") ?? 0)
        })
        
        //MARK: Handle team selection
        if selectedTabIndex == 1{
            sortedArray = dataModel?.teams?.values.dropFirst().first?.players?.sorted(by: { a, b in
                (Int(a.value.position ?? "0") ?? 0) < (Int(b.value.position ?? "0") ?? 0)
            })
        }
        cell.textLabel?.text = setCelldata(sortedArray: sortedArray, index: indexPath.row)
        return cell
    }
    func setCelldata(sortedArray : [Dictionary<String, Player>.Element]?,index : Int) -> String{
        let fullName = sortedArray?[index].value.nameFull ?? ""
        let isKeeper = sortedArray?[index].value.iskeeper ?? false
        let isCaptain = sortedArray?[index].value.iscaptain ?? false
        
        //MARK: Set cell text
        return (isKeeper && isCaptain) ? "\(fullName) (c & wk)" :
        (isCaptain) ? "\(fullName) (c)" :
        (isKeeper) ? "\(fullName) (wk)" :
        fullName
    }
}
extension TeamsVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        var sortedArray = dataModel?.teams?.values.first?.players?.sorted(by: { a, b in
            (Int(a.value.position ?? "0") ?? 0) < (Int(b.value.position ?? "0") ?? 0)
        })
        if selectedTabIndex == 1{
            sortedArray = dataModel?.teams?.values.dropFirst().first?.players?.sorted(by: { a, b in
                (Int(a.value.position ?? "0") ?? 0) < (Int(b.value.position ?? "0") ?? 0)
            })
        }
        guard let playerModel = sortedArray?[indexPath.row].value else {
            return
        }
        showPlayerInfo(playerModel: playerModel)
    }
}

//MARK: Collectionview set up
extension TeamsVC : UICollectionViewDataSource{
    //MARK: Number of Items in Section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    //MARK: Cell for Item at IndexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamTabCell", for: indexPath) as! TeamTabCell
        if selectedTabIndex == indexPath.row{
            cell.ibIndicator.backgroundColor = THEMECOLOR
            cell.ibTitle.textColor = THEMECOLOR
        }else{
            cell.ibIndicator.backgroundColor = .clear
            cell.ibTitle.textColor = .lightGray
        }
        let teamName = dataModel?.teams?.map{
            $0.value.nameFull
        }
        cell.ibTitle.text = teamName?[indexPath.row]
        return cell
    }
}

// Additional CollectionView Delegate Methods...
extension TeamsVC : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTabIndex = indexPath.row
        ibTableView.setContentOffset(CGPoint.zero, animated:false)//MARK: to move tableview cell to first index when Tab switched
        self.ibCollectionView.reloadData()
        self.ibTableView.reloadData()
    }
}

//MARK: CollectionView Flow Layout
extension TeamsVC : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2, height: 50)
    }
}

// Additional Extensions...

extension TeamsVC{
    //MARK: Show Player Info
    func showPlayerInfo(playerModel : Player){
        self.alert(title: "Player Info", message: getPlayerInfo(playerModel: playerModel))
    }
    
    //MARK: Get Player Info
    func getPlayerInfo(playerModel : Player?)-> String{
        var info = playerModel?.nameFull ?? ""
        info += (playerModel?.batting?.style?.rawValue.lowercased() ?? "") == "rhb" ? "\nRight Hand Batter" : "\nLeft Hand Batter"
        
        if let bowlingStyle = BowlingStyle(rawValue: playerModel?.bowling?.style?.lowercased() ?? "") {
            if bowlingStyle.rawValue == ""{
            } else {
                info += "\n" + bowlingStyle.displayName
            }
        } else {
            info += bowlingStyle(bowlingStyle: playerModel?.bowling?.style ?? "NA")
        }
        
        //info += "\n" + "Runs : " + (playerModel?.batting.runs ?? "NA")
        return info
    }
    
    //MARK: Bowling Style
    func bowlingStyle(bowlingStyle : String) -> String{
        var style = ""
        switch bowlingStyle.lowercased() {
        case "ob":
            style = "Off Break"
        case "lb":
            style = "Leg Break"
        case "lbg":
            style = "Leg Break Googly"
        case "sla":
            style = "Slow Left Arm Chinaman"
        case "slao":
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
            style = "NA"
        }
        return style == "NA" ? "" : ("\n" + style + " Bowler")
    }
}

