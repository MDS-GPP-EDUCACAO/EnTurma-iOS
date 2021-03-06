//
//  RankingViewController.swift
//  EnTurma
//
//  Created by Gabriel Silva on 6/16/15.
//  Copyright (c) 2015 mds. All rights reserved.
//

import UIKit

class RankingViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource,UIPickerViewDelegate {
    @IBOutlet weak var year: UITextField!
    @IBOutlet weak var grade: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var picker : UIPickerView?
    var firstResponderIndex = 0
    var pageReportGraph: PagerGraphViewController!
    var activityIndicator : UIActivityIndicatorView?
    var activityLabel : UILabel?
    var rankVC : PagerRankViewController!
    
    private var optionsForSelect = [
        ["2008","2009","2010","2011","2012","2013"],
        ["1° ano","2° ano","3° ano","4° ano","5° ano","6° ano","7° ano","8° ano","9° ano"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.picker = UIPickerView(frame: CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300))
        self.picker?.delegate = self;
        self.year.inputView = self.picker
        self.grade.inputView = self.picker
        
        self.activityLabel = UILabel(frame: CGRectMake(self.view.frame.width/2 - 150, self.view.frame.height/2-35, 300, 20))
        self.activityLabel!.text = "Requisitando Dados"
        self.activityLabel!.textColor = UIColor.grayColor()
        self.activityLabel!.alpha = 0;
        self.activityLabel?.textAlignment = NSTextAlignment.Center
        self.view.addSubview(self.activityLabel!)
        
        self.activityIndicator = UIActivityIndicatorView(frame: CGRectMake(self.view.frame.width/2 - 10, self.view.frame.height/2-10, 20, 20))
        self.activityIndicator?.hidesWhenStopped = true
        self.activityIndicator?.color = UIColor.grayColor()
        self.view.addSubview(self.activityIndicator!)
        
        scrollView.contentSize = CGSizeMake(view.frame.size.width, view.frame.size.height - 50)
        
        var tap = UITapGestureRecognizer(target: self, action: "removeKeybord")
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.scrollView.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func removeKeybord(){
        self.view.endEditing(true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var numberOfRows = self.optionsForSelect[self.firstResponderIndex].count
        return numberOfRows
    }
    
    // MARK: - PickerView  Data Source
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var title = self.optionsForSelect[self.firstResponderIndex][row]
        return title
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var text = self.optionsForSelect[self.firstResponderIndex][row]
        switch self.firstResponderIndex{
        case 0:
            self.year.text = text
        case 1:
            self.grade.text = text
        default:
            self.grade.text = text
        }
    }
    
    // MARK: - TextFild  Delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.firstResponderIndex = textField.tag
        self.picker?.reloadAllComponents()
        if textField.text.isEmpty{
            textField.text = self.optionsForSelect[self.firstResponderIndex][0]
        }
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        
        
        NSOperationQueue.mainQueue().addOperationWithBlock({
            
            UIMenuController.sharedMenuController().setMenuVisible(false, animated: false)
        });
        if action == Selector("paste:"){
            
            return false
            
        }
        
        return false
    }

    
    @IBAction func requestRanking(sender: AnyObject) {

        
        if self.grade.text.isEmpty ||
            self.year.text.isEmpty{
                
                UIAlertView().showFillFieldsAlert()
                
        }else{
        
        self.removeKeybord()
        
        var year = self.year.text
        var grade = self.grade.text
        
        var params = ["year":year, "grade":grade]
        
        self.showActivityIndicator(true)
        
        var rest = RESTFullManager(params: params)
        rest.requestRanking({ (jsonObject) -> Void in
            self.showActivityIndicator(false)
            
            self.showRanking(jsonObject)
            
        }, failure: { () -> Void in
            println("Error")
            self.showActivityIndicator(false)
        })
            
        }
//
    }
    
    
    
    func showRanking(jsonObject: NSDictionary){
        

        var rankVCFrame = CGRectMake(view.frame.origin.x, year.frame.origin.y + 130, view.frame.width, 370)
        
        if rankVC == nil{
        
        rankVC = PagerRankViewController(jsonObject: jsonObject)
        rankVC.viewDidLoad()
        rankVC.view.frame = rankVCFrame

        
        scrollView.contentSize = CGSizeMake(view.frame.width, view.frame.width + rankVC.view.frame.height + 100)
            
        UIView.transitionWithView(scrollView, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                
            self.scrollView.scrollRectToVisible(CGRectMake(self.rankVC.view.frame.origin.x,self.rankVC.view.frame.origin.y+50, self.rankVC.view.frame.width, self.rankVC.view.frame.height), animated: true)
            
            
            self.scrollView.addSubview(self.rankVC.view)
                
                }, completion: { finished in
                    
            })

        
        }else{
            rankVC.view.removeFromSuperview()
            view.setNeedsDisplay()
            rankVC = PagerRankViewController(jsonObject: jsonObject)
            rankVC.viewDidLoad()
            rankVC.view.frame = rankVCFrame
            

            UIView.transitionWithView(scrollView, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                
                self.scrollView.scrollRectToVisible(CGRectMake(self.rankVC.view.frame.origin.x,self.rankVC.view.frame.origin.y+50, self.rankVC.view.frame.width, self.rankVC.view.frame.height), animated: true)
                
                
                self.scrollView.addSubview(self.rankVC.view)
                
                }, completion: { finished in
                    
            })
            
            
            
        }
        
        
    }
    
    func showActivityIndicator(status : Bool){
        if status{
            self.activityIndicator?.startAnimating()
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.scrollView.alpha = 0
                self.activityLabel?.alpha = 1
            })
        }else{
            self.activityIndicator?.stopAnimating()
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.scrollView.alpha = 1
                self.activityLabel?.alpha = 0
            })
        }
    }


}
