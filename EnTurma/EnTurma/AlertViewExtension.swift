//
//  AlertViewExtension.swift
//  EnTurma
//
//  Created by Thiago-Bernardes on 6/19/15.
//  Copyright (c) 2015 mds. All rights reserved.
//

import UIKit

extension UIAlertView {
    
    func showFillFieldsAlert(){
        
        var alertMessage = NSLocalizedString("fill_all_the_text_fields_alert_message", comment: "")
        
        var fillFieldsAlert = UIAlertView(title: "" , message: alertMessage, delegate: self, cancelButtonTitle: "OK")
        
        fillFieldsAlert.show()
        
    }
    
    func showNoConnectionNetwork(){
        var alertMenssage = NSLocalizedString("no_connection", comment: "")
        var alert = UIAlertView(title: "Sem conecxão", message: alertMenssage, delegate: self, cancelButtonTitle: "OK")
        alert.show()
    }
    
    func showFailRequest(){
        var alertMenssage = NSLocalizedString("time_out_request", comment: "")
        var alert = UIAlertView(title: "Falha", message: alertMenssage, delegate: self, cancelButtonTitle: "OK")
        alert.show()
    }
    

}
