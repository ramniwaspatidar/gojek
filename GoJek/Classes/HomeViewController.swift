//
//  HomeViewController.swift
//  GoJek
//
//  Created by Ram Niwas on 9/6/19.
//  Copyright © 2019 Ramniwas. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let alphabets = (0...122).map { "\(Character(UnicodeScalar.init($0)!))" }.map { $0.uppercased() }
    
    @IBOutlet weak var homeTableView: UITableView!
    
    internal var viewModel : HomeViewModelling?
    var sectionIndexDict = [String : [HomeModel]]()
    var sectionIndex = [String]()
    
    var contactList = [HomeModel]() {
        didSet {
            DispatchQueue.main.sync {
                homeTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        setUp()
        checkVM()
        getContactList()
    }
    
    private func getSectionIndexList(){
        
        var temp = [String: [HomeModel]]()
        for contact in contactList {
            if let firstName = contact.first_name, !firstName.isEmpty {
                
                let firstChar = "\(firstName.first!)".uppercased()
                if alphabets.contains(firstChar) {
                    var array = temp[firstChar] ?? []
                    array.append(contact)
                    temp[firstChar] = array
                } else {
                    var array = temp["#"] ?? []
                    array.append(contact)
                    temp["#"] = array
                }
            }
        }
        sectionIndex = Array(temp.keys).sorted()
        for key in sectionIndex { sectionIndexDict[key] = temp[key] }
        
        DispatchQueue.main.sync {
            homeTableView.reloadData()
        }
    }
    
    //MARK: - Private Methods
    private func setUp() {
        homeTableView.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
    }
    
    private func checkVM() {
        if self.viewModel == nil {
            self.viewModel = HomeViewModel()
        }
    }
    
    // Mark : - make apis call
    
    private func getContactList(){
        
        viewModel?.getContact(contactHandler: { [weak self](responce,success) in
            guard self != nil else {return}
            self!.contactList = responce
            self!.getSectionIndexList()
            
        })
    }
    
    @IBAction func addContactButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "goToAddContact", sender: nil)
    }
}

// MARK-: Tableview Delegates

extension HomeViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionIndexDict.count == 0{return 0}
        return sectionIndexDict[sectionIndex[section]]?.count ?? 4}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {return UITableView.automaticDimension}
    
    func numberOfSections(in tableView: UITableView) -> Int {return sectionIndex.count}
    
        func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]!{
        return sectionIndex as [AnyObject]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionIndex
    }
    
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width, height:32))
        let title = UILabel(frame: CGRect(x:16, y:10, width:tableView.frame.size.width, height:12))
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.text = sectionIndex[section]
        view.addSubview(title);
        view.backgroundColor = UIColor.init(red: 236.0/256.0, green: 236.0/256.0, blue: 236.0/256.0, alpha: 1);
        return view
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {return 32;}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let homeCell = homeTableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        homeCell.selectionStyle = .none
        
        let key = self.sectionIndex[indexPath.section]
        if let dataModel = sectionIndexDict[key]?[indexPath.row] {
            homeCell.setData(dataModel)
        }
        return homeCell
    }
    

}
