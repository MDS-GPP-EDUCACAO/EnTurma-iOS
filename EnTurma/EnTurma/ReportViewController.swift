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
    
    var picker : UIPickerView?
    var firstResponderIndex = 0
    var pageReportGraph: PagerGraphViewController!
    
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
        self.scrollView.contentSize = CGSizeMake(view.frame.width, view.frame.height - 50)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
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
            case 4:
                        self.test_type.text = text
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
    }
    
    
    @IBAction func requestReport(sender: AnyObject) {
        self.prepareParams()
    }
    
    private func prepareParams(){
        //request Rest
        var year = self.year.text
        var grade = self.grade.text
        var state = self.state.text
        var test_type = self.test_type.text
        var local = self.local.text
        
        var params = ["year":year, "grade":grade, "state":state, "test_type":test_type, "local":local,"public_type": "Total"]

        var rest = RESTFullManager(params: params)
        rest.requestReport({ (jsonObject) -> Void in
            self.plotData(jsonObject)
        }, failure: { () -> Void in
            
        })
    }
    
    func plotData(jsonObject : NSDictionary) -> Void{
        
        var rates: NSDictionary = jsonObject.objectForKey("rates") as! NSDictionary
        var ideb: NSDictionary = jsonObject.objectForKey("ideb")as! NSDictionary
        
        
        var grades = ["1","2","3","4","5","6"]
        var idebGrades = ideb.objectForKey("ideb_grade_ids") as! NSArray
        
        var idebScores = ideb.objectForKey("ideb") as! NSArray
        var evasionScores = rates.objectForKey("evasion") as! NSArray
        var performanceScores = rates.objectForKey("performance") as! NSArray
        var distortionScores = rates.objectForKey("distortion") as! NSArray
        
        
        if(pageReportGraph == nil){
            
            pageReportGraph = PagerGraphViewController(reportGradesIdeb:  idebGrades, firstClassScoresIdeb: idebScores, indexGrades: grades, firstClassEvasionScores: evasionScores, firstClassPerformanceScores: performanceScores, firstClassDistortionScores: distortionScores)
            
            pageReportGraph.view.frame = CGRectMake(0, scrollView.contentSize.height - 100, view.frame.width, view.frame.width)
        
            UIView.transitionWithView(scrollView, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                
                self.scrollView.addSubview(self.pageReportGraph.view)
                
                
                }, completion: { finished in
                    
            })
            
            
            scrollView.contentSize = CGSizeMake(view.frame.width, scrollView.contentSize.height + pageReportGraph.view.frame.height + 40 )
            
            scrollView.scrollRectToVisible(CGRectMake(pageReportGraph.view.frame.origin.x,pageReportGraph.view.frame.origin.y+100, pageReportGraph.view.frame.width, pageReportGraph.view.frame.height+40), animated: true)

        }else{
            
            pageReportGraph = PagerGraphViewController(reportGradesIdeb:  idebGrades, firstClassScoresIdeb: idebScores, indexGrades: grades, firstClassEvasionScores: evasionScores, firstClassPerformanceScores: performanceScores, firstClassDistortionScores: distortionScores)
            

            
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
    
    func setupGraph(yValeus : NSArray, graphTitleString : String, graphDescription : String) -> EnTurmaLineChartView{
        
        let chartViewFrame = CGRectMake(0, 10, view.bounds.width, self.view.bounds.width)
        
        var initialYear = self.year.text.toInt()!
        
        var xValues:[String] = []
        
        for i in initialYear...2013{
            xValues.append("\(i)")
        }
        
        var newChart = EnTurmaLineChartView(singleLineGraphframe: chartViewFrame, xValues: xValues, yValues: yValeus, graphTitleString: graphTitleString, graphTextDescription: graphDescription)
    
        newChart.animate(yAxisDuration: 2.0)
        return newChart
    }
    
    func createViewController(title:String, graph : EnTurmaLineChartView) -> UIViewController{
        var controller : UIViewController = UIViewController()
        controller.title = title
        controller.view.addSubview(graph)
        return controller
    }
    
  
}
