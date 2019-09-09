//
//  AddContactViewController.swift
//  GoJek
//
//  Created by Ram Niwas on 9/7/19.
//  Copyright © 2019 Ramniwas. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {
    @IBOutlet weak var addContactTableView: UITableView!
    @IBOutlet weak var profileImg: UIImageView!
    
    var contectInfoArray = [InfoStruct]()
    var detailDict : HomeModel?
    internal var viewModel : AddInfoViewModelling?
    var dictInfo = [String : AnyObject]()
    var contact_id : String = ""

    var isEdit : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    //MARK: - Private Methods
    private func setUp() {
        checkVM()
        self.contectInfoArray = (self.viewModel?.prepareInfo(dictInfo: dictInfo))!
        addContactTableView.register(UINib(nibName: "AddContactCell", bundle: nil), forCellReuseIdentifier: "AddContactCell")
        
        if self.isEdit {
            let imgUrl : URL = URL(string: self.detailDict?.profile_pic ?? "")!
            self.profileImg!.sd_setImage(with:imgUrl , placeholderImage: #imageLiteral(resourceName: "placeholder_photo"))
            self.title = "Edit Contact"
        }
    }
    
    private func checkVM() {
        if self.viewModel == nil {
            self.viewModel = AddContactVM()
        }
    }
    
     @IBAction func cameraButtonAction(_ sender: Any){ImagePickerManager().pickImage(self,0){image,url in
        self.profileImg.image = (image as! UIImage)
 
    }}
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitButtonAction(_ sender: Any) {
        
        self.viewModel?.validateFields(addDataArray: contectInfoArray, validHandler: {(param,msg,success)in
            
            if success {
                self.viewModel?.addContact(param: param, img: self.profileImg.image!, isEdit: self.isEdit, contact_id: self.contact_id, addContactHandler:{(success,msg)in
                    
                    self.navigationController?.popViewController(animated: true)
                })
            }
            else {
                Utility.util.alertController(title: "", message: msg, okButtonTitle: "OK", completionHandler: {(value) in })
            }
        })
    }
}


// MARK-: Tableview Delegates
extension AddContactViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {return contectInfoArray.count}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {return UITableView.automaticDimension}
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let addCell = addContactTableView.dequeueReusableCell(withIdentifier: "AddContactCell", for: indexPath) as! AddContactCell
        addCell.selectionStyle = .none
        addCell.textField.delegate = self
        addCell.textField.tag = indexPath.row
        addCell.configureAddInfoCell(dict: contectInfoArray[indexPath.row], isEdit: true)
       
        return addCell
    }
}

extension AddContactViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let point = addContactTableView.convert(textField.bounds.origin, from: textField)
        let index = addContactTableView.indexPathForRow(at: point)
        
        let str = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        contectInfoArray[(index?.row)!].value = str
        return true
    }
}
