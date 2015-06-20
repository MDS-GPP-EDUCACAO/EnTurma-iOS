//
//  UIActivityIndicatorViewExtension.swift
//  EnTurma
//
//  Created by Thiago-Bernardes on 6/19/15.
//  Copyright (c) 2015 mds. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {

    
    
    func showActivityIndicator(status : Bool,parentView: UIView, activityLabel: UILabel){
        if status{
            self.startAnimating()
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                parentView.alpha = 0
                activityLabel.alpha = 1
            })
        }else{
            self.stopAnimating()
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                parentView.alpha = 1
               activityLabel.alpha = 0
            })
        }
    }

    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
