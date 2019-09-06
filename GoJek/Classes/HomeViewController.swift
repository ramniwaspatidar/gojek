//
//  HomeViewController.swift
//  GoJek
//
//  Created by Ram Niwas on 9/6/19.
//  Copyright © 2019 Ramniwas. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var homeTableView: UITableView!
    
    internal var viewModel : HomeViewModelling?
    
    var contactList = [HomeModel]() {
        didSet {
            DispatchQueue.main.sync {
                homeTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        checkVM()
        getContactList()
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
            
        })
    }
    
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }
  
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let homeCell = homeTableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        homeCell.setData(contactList[indexPath.row])
        
        
        return homeCell
    }
    
}
