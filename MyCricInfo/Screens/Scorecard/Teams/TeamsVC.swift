//
//  TeamsVC.swift
//  MyCricInfo
//


import UIKit

class TeamsVC: UIViewController {
    
    @IBOutlet weak var ibTableView: UITableView!
    
    @IBOutlet weak var ibCollectionView: UICollectionView!
    
    @IBOutlet weak var ibActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var viewInfo: UIView!
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblInfo: UILabel!
    
    let network = GenericNetworkCall()
    var dataModel : DataModel?
    var selectedTabIndex = 0 //MARK: for Tab switching reference
    var matchUrl = ""
    var navBarTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.fetchData()
    }
    func setUpUI(){
        self.title = "Squads"
        self.navigationController?.navigationBar.setUpNavBar()
        let showInfo = UIBarButtonItem(title: "Info", style: .plain, target: self, action: #selector(showInfoTapped(sender:)))
        viewBackground.isHidden = true
        viewInfo.isHidden = true
        viewInfo.layer.cornerRadius = 8
        navigationItem.rightBarButtonItems = [showInfo]
        ibTableView.tableFooterView = UIView()
        ibCollectionView.register(UINib(nibName: "TeamTabCell", bundle: nil), forCellWithReuseIdentifier: "TeamTabCell")
        let dummyViewHeight = CGFloat(40) //MARK: to prevent overlapping of header and tableview cell content
        self.ibTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.ibTableView.bounds.size.width, height: dummyViewHeight))
        self.ibTableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bgViewTapped))
        viewBackground.addGestureRecognizer(tapGesture)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    @objc func showInfoTapped(sender : UIBarButtonItem){
        viewBackground.isHidden = false
        viewInfo.isHidden = false
    }
    @objc func bgViewTapped(){
        viewBackground.isHidden = true
        viewInfo.isHidden = true
    }
    @IBAction func btnCloseTouchUpInside(_ sender: UIButton) {
        viewBackground.isHidden = true
        viewInfo.isHidden = true
    }
    
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
    func fetchData(){
        self.getResponseData { (response) in
            switch response {
            case .success(let data):
                self.dataModel = data!
                DispatchQueue.main.async {
                    let time = data?.matchdetail.match.time ?? ""
                    let date = data?.matchdetail.match.date ?? ""
                    let dateConverted = convertDateStringDynamic(dateString: date, inputDateFormat: "MM/dd/yyyy",outputDateFormat: "EEEE, MMM d, yyyy")
                    let venue = data?.matchdetail.venue.name ?? ""
                    self.lblInfo.text = dateConverted + " " + time + " - " + venue
                    self.ibTableView.reloadData()
                    self.ibCollectionView.reloadData()
                }
            case .failure(let err):
                print("ERROR \(err)")
                self.alert(title: "Alert", message: err.message ?? "OOPS!!Something went wrong!!")
            }
        }
    }
}
//MARK: Tableview set up
extension TeamsVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel?.teams.values.first?.players.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        var sortedArray = dataModel?.teams.values.first?.players.sorted(by: { a, b in
            (Int(a.value.position) ?? 0) < (Int(b.value.position) ?? 0)
        })
        if selectedTabIndex == 1{
            sortedArray = dataModel?.teams.values.dropFirst().first?.players.sorted(by: { a, b in
                (Int(a.value.position) ?? 0) < (Int(b.value.position) ?? 0)
            })
        }
        let fullName = sortedArray?[indexPath.row].value.nameFull ?? ""
        let isKeeper = sortedArray?[indexPath.row].value.iskeeper ?? false
        let isCaptain = sortedArray?[indexPath.row].value.iscaptain ?? false

        cell.textLabel?.text = (isKeeper && isCaptain) ? "\(fullName) (c & wk)" :
        (isCaptain) ? "\(fullName) (c)" :
        (isKeeper) ? "\(fullName) (wk)" :
        fullName
        return cell
    }
    
}
extension TeamsVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        var sortedArray = dataModel?.teams.values.first?.players.sorted(by: { a, b in
            (Int(a.value.position) ?? 0) < (Int(b.value.position) ?? 0)
        })
        if selectedTabIndex == 1{
            sortedArray = dataModel?.teams.values.dropFirst().first?.players.sorted(by: { a, b in
                (Int(a.value.position) ?? 0) < (Int(b.value.position) ?? 0)
            })
        }
        let vc = PlayerDetailsVC()
        vc.playerModel = sortedArray?[indexPath.row].value
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "Player"
        cell.textLabel?.textColor = .darkGray
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

//MARK: Collectionview set up

extension TeamsVC : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamTabCell", for: indexPath) as! TeamTabCell
        if selectedTabIndex == indexPath.row{
            cell.ibIndicator.backgroundColor = THEMECOLOR
            cell.ibTitle.textColor = THEMECOLOR
        }else{
            cell.ibIndicator.backgroundColor = .clear
            cell.ibTitle.textColor = .lightGray
        }
        let teamName = dataModel?.teams.map{
            $0.value.nameFull
        }
        cell.ibTitle.text = teamName?[indexPath.row]
        return cell
    }
}
extension TeamsVC : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTabIndex = indexPath.row
        ibTableView.setContentOffset(CGPoint.zero, animated:false)//MARK: to move tableview cell to first index when Tab switched
        self.ibCollectionView.reloadData()
        self.ibTableView.reloadData()
    }
}
extension TeamsVC : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2, height: 50)
    }
}
//MARK: API CALL
extension TeamsVC{
    func getResponseData(completion: @escaping
                         (Swift.Result<DataModel?, GenericNetworkCall.ErrorPOJO>) -> Void) {
        if isConnectedToNetwork(){
            self.ibActivityIndicator.startAnimating()
            network.fetchData(url: matchUrl, method: .get, params: [String : Any](), responseClass: DataModel.self) { (response) in
                DispatchQueue.main.async {
                    self.ibActivityIndicator.stopAnimating()
                }
                switch response {
                case .success(let data):
                    completion(.success(data))
                case .failure(let err):
                    print("ERROR \(err)")
                    completion(.failure(err))
                }
            }
        }else{
            self.alert(title: "Alert", message: "Connect to internet")
        }
        
    }
}
