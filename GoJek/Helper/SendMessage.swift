//
//  SendMessage.swift
//  GoJek
//
//  Created by Ram Niwas on 9/8/19.
//  Copyright © 2019 Ramniwas. All rights reserved.
//

import UIKit
import Messages
import MessageUI

class SendMessage: NSObject,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate {
    
  var msgHandler : ((MFMessageComposeViewController) -> Void)?
  var completeHandler : ((MFMailComposeViewController) -> Void)?

    
    func showMessagePop(_ controller : UIViewController, messageHandler : @escaping (MFMessageComposeViewController) -> Void) {
        if MFMessageComposeViewController.canSendText() == true {
            let recipients:[String] = ["info@gojek.com"]
            let messageController = MFMessageComposeViewController()
            messageController.messageComposeDelegate  = self
            messageController.recipients = recipients
            messageController.body = "Your_text"
            controller.present(messageController, animated: true, completion: nil)
        } else {
            print("Message can't send")
        }
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        msgHandler!(controller)
    }
    
    func sendEmail(_ controller : UIViewController, mailHandler : @escaping (MFMailComposeViewController) -> Void) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["you@yoursite.com"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            controller.present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        completeHandler!(controller)

    }

}
