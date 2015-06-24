//
//  ReportViewController.swift
//  EnTurma
//
//  Created by Gabriel Silva on 6/16/15.
//  Copyright (c) 2015 mds. All rights reserved.
//

import UIKit
import Alamofire

class ReportViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var grade: UITextField!
    @IBOutlet weak var year: UITextField!
    @IBOutlet weak var test_type: UITextField!
    @IBOutlet weak var local: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var font: UITextField!
    
    var picker : UIPickerView?
    var firstResponderIndex = 0
    var pageReportGraph: PagerGraphViewController!
    var activityIndicator : UIActivityIndicatorView?
    var activityLabel : UILabel?
    
    private var optionsForSelect = [["AC","AL","AM","AP","BA","CE","DF","ES","GO","MA","MG","MS","MT","PA","PB","PE","PI","PR","RJ","RN","RO","RR","RS","SC","SE","SP","TO"],
        ["1° ano","2° ano","3° ano","4° ano","5° ano","6° ano","7° ano","8° ano","9° ano"],
        ["2008","2009","2010","2011","2012","2013"],
        ["Total","Privada", "Publica"],
        ["Total", "Municipal","Estadual","Federal"],
        ["Total", "Urbana", "Rural"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.picker = UIPickerView(frame: CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300))
        self.picker?.delegate = self;
        self.state.inputView = self.picker
        self.grade.inputView = self.picker
        self.year.inputView = self.picker
        self.test_type.inputView = self.picker
        self.local.inputView = self.picker
        self.font.inputView = self.picker
        self.scrollView.contentSize = CGSizeMake(view.frame.width, view.frame.height - 50)
        
        var tap = UITapGestureRecognizer(target: self, action: "removeKeybord")
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.scrollView.addGestureRecognizer(tap)
        
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
        
        self.title = "Relatório"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func removeKeybord(){
        self.view.endEditing(true)
    }
    
    // MARK: - PickerView  delegate
    
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
            self.state.text = text
        case 1:
            self.grade.text = text
        case 2:
            self.year.text = text
        case 3:
            self.test_type.text = text
            if  text == "Publica"{
                self.showFontTextFild()
            }else{
                self.hideFontTextfild()
            }
        case 4:
            self.font.text = text
        case 5:
            self.local.text = text
        default:
            self.test_type.text = text
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
    
    func showFontTextFild(){
        self.font.hidden = false
    }
    
    func hideFontTextfild(){
        self.font.hidden = true
    }
    
    
    @IBAction func requestReport(sender: AnyObject) {
        self.removeKeybord()
        
        if self.state.text.isEmpty ||
            self.grade.text.isEmpty ||
            self.year.text.isEmpty ||
            self.test_type.text.isEmpty ||
            self.local.text.isEmpty{
                
                UIAlertView().showFillFieldsAlert()
                
        }else{
            
            self.prepareParams()
            
        }
        
    }
    

    
    private func prepareParams(){
        //request Rest
        var year = self.year.text
        var grade = self.grade.text
        var state = self.state.text
        var test_type = self.test_type.text
        var local = self.local.text
        var publicType : String = ""
        if(self.font.text.isEmpty){
            publicType = "Total"
        }else{
            publicType = self.font.text
        }
        
        var params = ["year":year, "grade":grade, "state":state, "test_type":test_type, "local":local,"public_type": publicType]
        
        activityIndicator?.showActivityIndicator(true, parentView: scrollView, activityLabel: activityLabel!)
        
        var rest = RESTFullManager(params: params)
        rest.requestReport({ (jsonObject) -> Void in
            self.plotData(jsonObject)
            println(jsonObject)
            self.activityIndicator?.showActivityIndicator(false, parentView: self.scrollView, activityLabel: self.activityLabel!)
            }, failure: { () -> Void in
                UIAlertView().showFailRequest()
                self.activityIndicator?.showActivityIndicator(false, parentView: self.scrollView, activityLabel: self.activityLabel!)
        })
    }
    
    
    func plotData(jsonObject : NSDictionary) -> Void{
        
        var rates: NSDictionary = jsonObject.objectForKey("rates") as! NSDictionary
        var ideb: NSDictionary = jsonObject.objectForKey("ideb")as! NSDictionary
        var initialYear = (jsonObject.objectForKey("year") as! String).toInt()!
        var initialGrade = jsonObject.objectForKey("grade") as! Int
        var statics:[String : Dictionary<String, AnyObject?>]!

        
        var grades = PagerGraphViewController.selectXData(initialYear, initialGrade: initialGrade)
       
        var idebGrades : NSArray!
        
        var idebScores : NSArray!
        
        var idebStatus = ideb.objectForKey("status") as! String
        
        if idebStatus == "unavailable"{
            idebGrades = []
            idebScores = []
        statics = parserStatisticsToJSON(rates, ideb: ideb, idebStatus: false)
        }else{
            idebGrades = ideb.objectForKey("ideb_years") as! NSArray
            idebScores = ideb.objectForKey("ideb") as! NSArray
            statics = parserStatisticsToJSON(rates, ideb: ideb, idebStatus: true)
        }
        var evasionScores = rates.objectForKey("evasion") as! NSArray
        var performanceScores = rates.objectForKey("performance") as! NSArray
        var distortionScores = rates.objectForKey("distortion") as! NSArray

        
        if(pageReportGraph == nil){
            
            pageReportGraph = PagerGraphViewController(reportGradesIdeb:  idebGrades, firstClassScoresIdeb: idebScores, indexGrades: grades, firstClassEvasionScores: evasionScores, firstClassPerformanceScores: performanceScores, firstClassDistortionScores: distortionScores, statics: statics)
            
            pageReportGraph.view.frame = CGRectMake(0, scrollView.contentSize.height - 100, view.frame.width, view.frame.width + 40)
            
            UIView.transitionWithView(scrollView, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                
                self.scrollView.addSubview(self.pageReportGraph.view)
                
                
                }, completion: { finished in
                    
            })
            
            
            scrollView.contentSize = CGSizeMake(view.frame.width, scrollView.contentSize.height + pageReportGraph.view.frame.height + 40 )
            
            scrollView.scrollRectToVisible(CGRectMake(pageReportGraph.view.frame.origin.x,pageReportGraph.view.frame.origin.y+100, pageReportGraph.view.frame.width, pageReportGraph.view.frame.height+40), animated: true)
            
        }else{
            
            pageReportGraph = PagerGraphViewController(reportGradesIdeb:  idebGrades, firstClassScoresIdeb: idebScores, indexGrades: grades, firstClassEvasionScores: evasionScores, firstClassPerformanceScores: performanceScores, firstClassDistortionScores: distortionScores, statics: statics)
            
            
            
            UIView.transitionWithView(scrollView, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                self.pageReportGraph.view.removeFromSuperview()
                self.view.setNeedsDisplay()
                self.scrollView.contentSize = CGSizeMake(self.view.frame.width, self.scrollView.contentSize.height - self.pageReportGraph.view.frame.height - 40 )
                self.pageReportGraph.view.frame = CGRectMake(0, self.scrollView.contentSize.height - 100, self.view.frame.width, self.view.frame.width)
                
                
                }, completion: { finished in
                    
                    UIView.transitionWithView(self.scrollView, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                        self.scrollView.addSubview(self.pageReportGraph.view)
                        self.scrollView.contentSize = CGSizeMake(self.view.frame.width, self.scrollView.contentSize.height + self.pageReportGraph.view.frame.height + 40 )
                        
                        self.scrollView.scrollRectToVisible(CGRectMake(self.pageReportGraph.view.frame.origin.x,self.pageReportGraph.view.frame.origin.y+100, self.pageReportGraph.view.frame.width, self.pageReportGraph.view.frame.height+40), animated: false)
                        
                        
                        }, completion: { finished in
                            
                    })
            })
        }
    }
    
    func parserStatisticsToJSON(rates : NSDictionary, ideb: NSDictionary, idebStatus:Bool) -> [String : Dictionary<String, AnyObject?>]{
        
        var statics :[String : Dictionary<String, AnyObject?>]!
        
        if idebStatus{
            statics = ["ideb" :["average":ideb.objectForKey("ideb_average"),"standard":ideb.objectForKey("ideb_standard_deviation"),"variance":ideb.objectForKey("ideb_variance")],"evasion": ["average":rates.objectForKey("evasion_average"),"standard":rates.objectForKey("evasion_standard_deviation"),"variance":rates.objectForKey("evasion_variance")],
                "performance": ["average":rates.objectForKey("performance_average"),"standard":rates.objectForKey("performance_standard_deviation"),"variance":rates.objectForKey("performance_variance")],
                "distortion": ["average":rates.objectForKey("distortion_average"),"standard":rates.objectForKey("distortion_standard_deviation"),"variance":rates.objectForKey("distortion_variance")]
            ]

        }else{
            statics = ["evasion": ["average":rates.objectForKey("evasion_average"),"standard":rates.objectForKey("evasion_standard_deviation"),"variance":rates.objectForKey("evasion_variance")],
            "performance": ["average":rates.objectForKey("performance_average"),"standard":rates.objectForKey("performance_standard_deviation"),"variance":rates.objectForKey("performance_variance")],
            "distortion": ["average":rates.objectForKey("distortion_average"),"standard":rates.objectForKey("distortion_standard_deviation"),"variance":rates.objectForKey("distortion_variance")]
            ]
        }
        return statics
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
    
    
}
