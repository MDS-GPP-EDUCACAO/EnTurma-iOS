//
//  GraphDescriptionView.swift
//  EnTurma
//
//  Created by Thiago-Bernardes on 6/11/15.
//  Copyright (c) 2015 mds. All rights reserved.
//

import UIKit

class GraphDescriptionView: UITextView {
    
    var graphDescription : String!
 
    // Do any additional setup after loading the view.
    
    init(frame: CGRect, descriptionText: String){
        
        super.init(frame: frame, textContainer:nil)
        graphDescription = descriptionText
        commomInit();
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commomInit(){
        
        backgroundColor = UIColor(white: 1, alpha: 0)
        
        backgroundColor = UIColor(white: 1, alpha: 0)
        text = graphDescription
        addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
        font =  UIFont(name: "HelveticaNeue-Light", size: 18)!
        textColor = UIColor(white: 0, alpha: 1)
        editable = false
        textAlignment = .Center
        
    }

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        
        
        if(keyPath == "contentSize"){
            
            var textView = object as! UITextView
            var topoffset = (textView.bounds.size.height - textView.contentSize.height * textView.zoomScale)/2
            topoffset = (topoffset < 0.0 ? 0.0 : topoffset)
            textView.contentOffset = CGPointMake(0, -topoffset)
            
        }
        
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        removeObserver(self, forKeyPath: "contentSize")
        nextResponder()?.touchesBegan(touches, withEvent: event)
        UIView.transitionWithView(superview!.superview!, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            // remove the front object...
            
            // ... and add the other object
            self.superview?.removeFromSuperview()

           // self.removeFromSuperview()
            
            }, completion: { finished in
                // any code entered here will be applied
                // .once the animation has completed
        })

        
        
    }
    


}
