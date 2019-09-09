//
//  ContactDetailViewController.swift
//  GoJek
//
//  Created by Ram Niwas on 9/7/19.
//  Copyright © 2019 Ramniwas. All rights reserved.
//

import UIKit
import ObjectMapper
import Messages
import MessageUI

class ContactDetailViewController: UIViewController  {
    
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
    
    var detailDict : HomeModel?
    var contactDetailArray = [InfoStruct](){
        didSet{
            DispatchQueue.main.async {
                self.detailTableView.reloadData()
            }
        }
    }
    internal var viewModel : AddInfoViewModelling?
    var dictInfo = [String : AnyObject]()
    var contact_id : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        getContactDetails()
    }
    
    //MARK: - Private Methods
    private func setUp() {
        checkVM()
        detailTableView.register(UINib(nibName: "AddContactCell", bundle: nil), forCellReuseIdentifier: "AddContactCell")
    }
    
    private func checkVM() {
        if self.viewModel == nil {
            self.viewModel = AddContactVM()
        }
    }
    
    private func updateUI(){
        DispatchQueue.main.async {
            
            self.detailTableView.isHidden = false
            self.nameLabel.text =  self.contactDetailArray[0].value + " " + self.contactDetailArray[1].value
            self.favButton.setImage((self.detailDict?.favorite == true) ? #imageLiteral(resourceName: "favourite_button_selected") :#imageLiteral(resourceName: "favourite_button"), for: .normal)
            
            let imgUrl : URL = URL(string: self.detailDict?.profile_pic ?? "")!
            self.profileImg!.sd_setImage(with:imgUrl , placeholderImage: #imageLiteral(resourceName: "placeholder_photo"))
        }
    }
    
    // MARK-:Button Action
    
    @IBAction func editButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: kGoToAddContact, sender: self.detailDict)
    }
    @IBAction func messageButtonAction(_ sender: Any) {
          sendMessage()
    }
    
    @IBAction func mailButtonAction(_ sender: Any) {
        sendEmail()
    }
    
    @IBAction func callButtonAction(_ sender: Any) {
        if let url = URL(string: "tel://\( self.detailDict?.phone_number ?? "")"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler:nil)
        }
    }
    
    @IBAction func favButtonAction(_ sender: Any) {
        (self.detailDict?.favorite == false) ? (self.detailDict?.favorite = true) :(self.detailDict?.favorite = false)
        self.favButton.setImage((self.detailDict?.favorite == true) ? #imageLiteral(resourceName: "favourite_button_selected") :#imageLiteral(resourceName: "favourite_button"), for: .normal)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kGoToAddContact {
            if let addView = segue.destination as? AddContactViewController {
                addView.dictInfo = dictInfo
                addView.isEdit = true
                addView.contact_id = self.contact_id!
                addView.detailDict = self.detailDict
            }
        }
    }

    
    // apis call
    func getContactDetails(){
        self.viewModel?.getContactDetails(self.contact_id!, contactHandler: {[weak self](responce,sucess) in
            guard self != nil else {return}
            
            self!.dictInfo = responce
            self!.detailDict = Mapper<HomeModel>().map(JSON: responce)
            self!.contactDetailArray = (self!.viewModel?.prepareInfo(dictInfo: self!.dictInfo))!
            self!.updateUI()
        })
    }
}

// MARK-: Tableview Delegates
extension ContactDetailViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {return contactDetailArray.count}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {return (indexPath.row == 0 || indexPath.row == 1) ?  0: UITableView.automaticDimension}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detialcell = detailTableView.dequeueReusableCell(withIdentifier: "AddContactCell", for: indexPath) as! AddContactCell
        detialcell.selectionStyle = .none
        detialcell.textField.tag = indexPath.row
        detialcell.configureAddInfoCell(dict: contactDetailArray[indexPath.row], isEdit: false)
        detialcell.isHidden = (indexPath.row == 0 || indexPath.row == 1) ?  true: false
        
        return detialcell
    }
}

extension ContactDetailViewController : MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func sendMessage(){
        if MFMessageComposeViewController.canSendText() == true {
            let recipients:[String] = ["99687363734"]
            let messageController = MFMessageComposeViewController()
            messageController.messageComposeDelegate  = self
            messageController.recipients = recipients
            messageController.body = ""
            self.present(messageController, animated: true, completion: nil)
        } else {
            print("Message can't send")
        }
    }
}

extension ContactDetailViewController : MFMailComposeViewControllerDelegate{
    func sendEmail(){
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["you@yoursite.com"])
            mail.setMessageBody("", isHTML: true)
            self.present(mail, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        controller.dismiss(animated: true, completion: nil)

    }
}


