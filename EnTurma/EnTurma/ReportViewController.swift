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
    
    var picker : UIPickerView?
    var firstResponderIndex = 0
    
    var pageMenu: CAPSPageMenu?
    
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
        
        // Create variables for all view controllers you want to put in the
        // page menu, initialize them, and add each to the controller array.
        // (Can be any UIViewController subclass)
        // Make sure the title property of all view controllers is set
        var controllerArray : [UIViewController] = []
        
        
        if  rates.objectForKey("status") as! String == "available"{
            var evasionChart = self.setupGraph(rates.objectForKey("evasion") as! NSArray, graphTitleString: "Evasão", graphDescription: " O Índice de Evasão retrata o percentual de alunos que deixaram de frequentar a escola, caracterizando dessa forma abandono escolar. Tal índice é obtido por meio do Censo Escolar pelo Inep e compõe o Índice de Desenvolvimento da Educação Brasileira (Ideb).")
            
            var peformanceChart = self.setupGraph(rates.objectForKey("performance") as! NSArray, graphTitleString: "Rendimento", graphDescription: " O Índice de Evasão retrata o percentual de alunos que deixaram de frequentar a escola, caracterizando dessa forma abandono escolar. Tal índice é obtido por meio do Censo Escolar pelo Inep e compõe o Índice de Desenvolvimento da Educação Brasileira (Ideb).")
            
            var distortionChart = self.setupGraph(rates.objectForKey("distortion") as! NSArray, graphTitleString: "Distorção", graphDescription: " O Índice de Evasão retrata o percentual de alunos que deixaram de frequentar a escola, caracterizando dessa forma abandono escolar. Tal índice é obtido por meio do Censo Escolar pelo Inep e compõe o Índice de Desenvolvimento da Educação Brasileira (Ideb).")
            
            var evasionController = self.createViewController("Evasão", graph: evasionChart)
            var peformanceController = self.createViewController("Rendimento", graph: peformanceChart)
            var distortionController = self.createViewController("Distorção", graph: distortionChart)
            
            controllerArray.append(evasionController)
            controllerArray.append(peformanceController)
            controllerArray.append(distortionController)
        }

        
        
        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        // Example:
        var parameters: [CAPSPageMenuOption] = [
            .MenuItemSeparatorWidth(0),
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .ViewBackgroundColor(UIColor.whiteColor()),
            .BottomMenuHairlineColor(UIColor.whiteColor()),
            .SelectionIndicatorColor(UIColor.blackColor()),
            .MenuMargin(20.0),
            .MenuHeight(40.0),
            .SelectedMenuItemLabelColor(UIColor.blackColor()),
            .UnselectedMenuItemLabelColor(UIColor(red: 127/255.0, green: 127/255.0, blue: 127/255.0, alpha: 1.0)),
            .MenuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 15.0)!),
            .UseMenuLikeSegmentedControl(true),
            .MenuItemSeparatorRoundEdges(false),
            .SelectionIndicatorHeight(2.0),
            .MenuItemSeparatorPercentageHeight(0)
            
        ]
        
        let pageMenuFrame = CGRectMake(0, 100, view.bounds.width, self.view.bounds.width+100)
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: pageMenuFrame, pageMenuOptions: parameters)
        
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.view.addSubview(pageMenu!.view)
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
    
    @IBAction func newReport(sender: AnyObject) {
        self.pageMenu!.view.removeFromSuperview()
        self.local.hidden = false
    }
}
