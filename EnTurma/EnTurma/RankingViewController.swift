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
    
    var picker : UIPickerView?
    var firstResponderIndex = 0
    var pageReportGraph: PagerGraphViewController!
    var activityIndicator : UIActivityIndicatorView?
    var activityLabel : UILabel?
    
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
        self.activityLabel!.alpha = 1;
        self.activityLabel?.textAlignment = NSTextAlignment.Center
        self.view.addSubview(self.activityLabel!)
        
        self.activityIndicator = UIActivityIndicatorView(frame: CGRectMake(self.view.frame.width/2 - 10, self.view.frame.height/2-10, 20, 20))
        self.activityIndicator?.hidesWhenStopped = true
        self.activityIndicator?.color = UIColor.grayColor()
        self.view.addSubview(self.activityIndicator!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    }

    
    @IBAction func requestRanking(sender: AnyObject) {
        var year = self.year.text
        var grade = self.grade.text
        
        var params = ["year":year, "grade":grade]
        
        self.activityIndicator?.startAnimating()
        
        var rest = RESTFullManager(params: params)
        rest.requestRanking({ (jsonObject) -> Void in
            println(jsonObject)
        }, failure: { () -> Void in
            println("Error")
        })

    }

}
