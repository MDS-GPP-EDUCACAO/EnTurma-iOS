//
//  CompareViewController.swift
//  EnTurma
//
//  Created by Gabriel Silva on 6/16/15.
//  Copyright (c) 2015 mds. All rights reserved.
//

import UIKit
import Alamofire

class CompareViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var grade: UITextField!
    @IBOutlet weak var secondTestType: UITextField!
    @IBOutlet weak var secondLocal: UITextField!
    @IBOutlet weak var secondState: UITextField!
    @IBOutlet weak var secondYear: UITextField!
    @IBOutlet weak var firstTestType: UITextField!
    @IBOutlet weak var firstLocal: UITextField!
    @IBOutlet weak var firstState: UITextField!
    @IBOutlet weak var firstYear: UITextField!
    
    private var optionsForSelect = [["2008","2009","2010","2011","2012","2013"],["AC","AL","AM","AP","BA","CE","DF","ES","GO","MA","MG","MS","MT","PA","PB","PE","PI","PR","RJ","RN","RO","RR","RS","SC","SE","SP","TO"],
        ["Total", "Urbana", "Rural"],
        ["Total","Privada", "Publica"],
        ["1° ano","2° ano","3° ano","4° ano","5° ano","6° ano","7° ano","8° ano","9° ano"],
        ["2008","2009","2010","2011","2012","2013"],["AC","AL","AM","AP","BA","CE","DF","ES","GO","MA","MG","MS","MT","PA","PB","PE","PI","PR","RJ","RN","RO","RR","RS","SC","SE","SP","TO"],
        ["Total", "Urbana", "Rural"],
        ["Total","Privada", "Publica"]]
    
    var firstResponderIndex = 0
     var picker : UIPickerView?
    var pageReportGraph: PagerGraphViewController!
    var activityIndicator : UIActivityIndicatorView?
    var activityLabel : UILabel?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.picker = UIPickerView(frame: CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300))
        self.picker?.delegate = self;
        self.firstYear.inputView = self.picker
        self.firstLocal.inputView = self.picker
        self.firstState.inputView = self.picker
        self.firstTestType.inputView = self.picker
        self.secondYear.inputView = self.picker
        self.secondState.inputView = self.picker
        self.secondLocal.inputView = self.picker
        self.secondTestType.inputView = self.picker
        self.grade.inputView = self.picker
        
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
    
    // MARK: - PickerView  delegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var numberOfRows = self.optionsForSelect[self.firstResponderIndex].count
        return numberOfRows
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var text = self.optionsForSelect[self.firstResponderIndex][row]
        switch self.firstResponderIndex{
        case 0:
            self.firstYear.text = text
        case 1:
            self.firstState.text = text
        case 2:
            self.firstLocal.text = text
        case 3:
            self.firstTestType.text = text
        case 4:
            self.grade.text = text
        case 5:
            self.secondYear.text = text
        case 6:
            self.secondState.text = text
        case 7:
            self.secondLocal.text = text
        case 8:
            self.secondTestType.text = text
        default:
            self.secondTestType.text = text
        }
    }
    
    // MARK: - PickerView  Data Source
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var title = self.optionsForSelect[self.firstResponderIndex][row]
        return title
    }
    
    // MARK: - TextFild  Delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.firstResponderIndex = textField.tag
        self.picker?.reloadAllComponents()
        
        if textField.text.isEmpty{
            textField.text = self.optionsForSelect[self.firstResponderIndex][0]
        }
    }
    @IBAction func requestCompare(sender: AnyObject) {
        
        if self.firstYear.text.isEmpty ||
        self.firstState.text.isEmpty ||
        self.firstLocal.text.isEmpty ||
        self.firstTestType.text.isEmpty ||
        self.grade.text.isEmpty ||
        self.secondYear.text.isEmpty ||
        self.secondState.text.isEmpty ||
        self.secondLocal.text.isEmpty ||
            self.secondTestType.text.isEmpty{
        
                UIAlertView().showFillFieldsAlert()
        }else{
            self.prepareParams()
        }
    }
    
    func prepareParams(){
        //request Rest
        var firstYear = self.firstYear.text
        var grade = self.grade.text
        var firstState = self.firstState.text
        var firstTestType = self.firstTestType.text
        var firstLocal = self.firstLocal.text
        var secondState = self.secondState.text
        var secondTestType = self.secondTestType.text
        var secondLocal = self.secondLocal.text
        var secondYear = self.secondYear.text
        
        var params = ["first_year":firstYear, "grade":grade, "first_state":firstState, "first_test_type":firstTestType, "first_local":firstLocal,"first_public_type": "Total","second_year":secondYear, "second_state":secondState, "second_test_type":secondTestType, "second_local":secondLocal,"second_public_type": "Total"]
        
        self.showActivityIndicator(true)
        var rest = RESTFullManager(params: params)
        rest.requestCompare({ (jsonObject) -> Void in
            self.plotData(jsonObject.objectForKey("first_report") as! NSDictionary, secondReport: jsonObject.objectForKey("second_report") as! NSDictionary)
            println(jsonObject)
            self.showActivityIndicator(false)
            }, failure: { () -> Void in
                UIAlertView().showFailRequest()
                self.showActivityIndicator(false)
        })
        
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
    
    func plotData(firstReport : NSDictionary, secondReport: NSDictionary){
        var firstSerialize = self.serializeDataToPlot(firstReport)
        var secondSerialize = self.serializeDataToPlot(secondReport)
        
        if(pageReportGraph == nil){
            
            pageReportGraph = PagerGraphViewController(compareGradesIdeb: firstSerialize[0] as! NSArray, firstClassScoresIdeb: firstSerialize[1] as! NSArray, secondClassScoresIdeb: secondSerialize[1] as! NSArray, indexGrades: firstSerialize[5] as! NSArray, firstClassEvasionScores: firstSerialize[2] as! NSArray, secondClassEvasionScores: secondSerialize[2] as! NSArray, firstClassPerformanceScores: firstSerialize[3] as! NSArray, secondClassPerformanceScores: secondSerialize[3] as! NSArray, firstClassDistortionScores: firstSerialize[4] as! NSArray, secondClassDistortionScores: secondSerialize[4] as! NSArray)
            
            pageReportGraph.view.frame = CGRectMake(0, scrollView.contentSize.height - 100, view.frame.width, view.frame.width)
            
            UIView.transitionWithView(scrollView, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                
                self.scrollView.addSubview(self.pageReportGraph.view)
                
                
                }, completion: { finished in
                    
            })
            
            
            scrollView.contentSize = CGSizeMake(view.frame.width, scrollView.contentSize.height + pageReportGraph.view.frame.height + 40 )
            
            scrollView.scrollRectToVisible(CGRectMake(pageReportGraph.view.frame.origin.x,pageReportGraph.view.frame.origin.y+100, pageReportGraph.view.frame.width, pageReportGraph.view.frame.height+40), animated: true)
            
        }else{
            
            pageReportGraph = PagerGraphViewController(compareGradesIdeb: firstSerialize[0] as! NSArray, firstClassScoresIdeb: firstSerialize[1] as! NSArray, secondClassScoresIdeb: secondSerialize[1] as! NSArray, indexGrades: firstSerialize[5] as! NSArray, firstClassEvasionScores: firstSerialize[2] as! NSArray, secondClassEvasionScores: secondSerialize[2] as! NSArray, firstClassPerformanceScores: firstSerialize[3] as! NSArray, secondClassPerformanceScores: secondSerialize[3] as! NSArray, firstClassDistortionScores: firstSerialize[4] as! NSArray, secondClassDistortionScores: secondSerialize[4] as! NSArray)
            
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
    
    func serializeDataToPlot(report : NSDictionary) -> NSArray{
        var rates: NSDictionary = report.objectForKey("rates") as! NSDictionary
        var ideb: NSDictionary = report.objectForKey("ideb")as! NSDictionary
        var initialYear = (report.objectForKey("year") as! String).toInt()!
        var initialGrade = report.objectForKey("grade") as! Int
        
        var grades = PagerGraphViewController.selectXData(initialYear, initialGrade: initialGrade)
        
        var idebGrades : NSArray!
        
        var idebScores : NSArray!
        
        var idebStatus = ideb.objectForKey("status") as! String
        
        if idebStatus == "unavailable"{
            idebGrades = []
            idebScores = []
            
        }else{
            idebGrades = ideb.objectForKey("ideb_years") as! NSArray
            idebScores = ideb.objectForKey("ideb") as! NSArray
        }
        var evasionScores = rates.objectForKey("evasion") as! NSArray
        var performanceScores = rates.objectForKey("performance") as! NSArray
        var distortionScores = rates.objectForKey("distortion") as! NSArray
        
        return [idebGrades,idebScores, evasionScores,performanceScores,distortionScores, grades]
    }
    
    

    
}
