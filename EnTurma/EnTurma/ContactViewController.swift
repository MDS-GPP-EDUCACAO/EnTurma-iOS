//
//  ContactViewController.swift
//  EnTurma
//
//  Created by Gabriel Silva on 6/16/15.
//  Copyright (c) 2015 mds. All rights reserved.
//

import UIKit
import MessageUI

class ContactViewController: UIViewController,MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendEmail(sender: AnyObject) {
        var picker = MFMailComposeViewController()
        picker.setToRecipients(["contatoenturma@gmail.com "])
        picker.mailComposeDelegate = self
        picker.setSubject("EnTurma contato - iOS")
        picker.setMessageBody("", isHTML: false)
        
        presentViewController(picker, animated: true, completion: nil)
    }

    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

}
