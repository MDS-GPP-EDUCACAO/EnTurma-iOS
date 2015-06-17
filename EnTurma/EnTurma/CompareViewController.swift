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
    
    @IBOutlet weak var firstPicker: UIPickerView!
    @IBOutlet weak var secondPicker: UIPickerView!
    @IBOutlet weak var newCompare: UIButton!
    
    private var json : NSDictionary = ["":""]
    
    var pageMenu: CAPSPageMenu?
    
    private var optionsForSelect : NSDictionary =
    ["state":["AC","AL","AM","AP","BA","CE","DF","ES","GO","MA","MG","MS","MT","PA","PB","PE","PI","PR","RJ","RN","RO","RR","RS","SC","SE","SP","TO"],
        "grades" : ["1° ano","2° ano","3° ano","4° ano","5° ano","6° ano","7° ano","8° ano","9° ano"],
        "years" : ["2008","2009","2010","2011","2012","2013"],
        "network" : ["Total","Privada", "Publica"],
        "public_type" : ["Total", "Municipal","Estadual","Federal"],
        "local" : ["Total", "Urbana", "Rural"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - PickerView  delegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 5
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var numberOfRows = 0
        
        switch component{
        case 0:
            numberOfRows = (optionsForSelect.objectForKey("state") as! NSArray).count
        case 1:
            numberOfRows = (optionsForSelect.objectForKey("grades") as! NSArray).count
        case 2:
            numberOfRows = (optionsForSelect.objectForKey("years") as! NSArray).count
        case 3:
            numberOfRows = (optionsForSelect.objectForKey("network") as! NSArray).count
        case 4:
            numberOfRows = (optionsForSelect.objectForKey("local") as! NSArray).count
        default:
            numberOfRows = 0
        }
        
        return numberOfRows
    }
    
    // MARK: - PickerView  Data Source
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        var title = ""
        
        switch component{
        case 0:
            title = (optionsForSelect.objectForKey("state") as! NSArray).objectAtIndex(row) as! String
        case 1:
            title = (optionsForSelect.objectForKey("grades") as! NSArray).objectAtIndex(row) as! String
        case 2:
            title = (optionsForSelect.objectForKey("years") as! NSArray).objectAtIndex(row) as! String
        case 3:
            title = (optionsForSelect.objectForKey("network") as! NSArray).objectAtIndex(row) as! String
        case 4:
            title = (optionsForSelect.objectForKey("local") as! NSArray).objectAtIndex(row) as! String
        default:
            title = ""
            }
        return title
    }
    @IBAction func requestCompare(sender: AnyObject) {
        self.prepareParams()
    }
    
    private func prepareParams(){
        //request Rest
        var state = self.titleForItemSelected(self.firstPicker, componet: 0)
        var grade = self.titleForItemSelected(self.firstPicker, componet: 1)
        var year = self.titleForItemSelected(self.firstPicker, componet: 2)
        var network = self.titleForItemSelected(self.firstPicker, componet: 3)
        var local = self.titleForItemSelected(self.firstPicker, componet: 4)
        
        var state2 = self.titleForItemSelected(self.secondPicker, componet: 0)
        var grade2 = self.titleForItemSelected(self.secondPicker, componet: 1)
        var year2 = self.titleForItemSelected(self.secondPicker, componet: 2)
        var network2 = self.titleForItemSelected(self.secondPicker, componet: 3)
        var local2 = self.titleForItemSelected(self.secondPicker, componet: 4)
        
        var params = ["first_year":year, "grade":grade, "first_state":state, "first_test_type":network, "first_local":local,"first_public_type": "Total","second_year":year2, "second_state":state2, "second_test_type":network2, "second_local":local2,"second_public_type": "Total"]
 
    
        var rest = RESTFullManager(params: params)
        rest.requestCompare({ (jsonObject) -> Void in
            self.json = jsonObject
            println(jsonObject)
            self.plotData(jsonObject)
            }, failure: { () -> Void in
                
        })
    }
    
    
    func plotData(jsonObject : NSDictionary) -> Void{
        
        
        var firstGrade : NSDictionary = jsonObject.objectForKey("first_report") as! NSDictionary
        var secondGrade : NSDictionary = jsonObject.objectForKey("second_report") as! NSDictionary
        
        var firstRates: NSDictionary = firstGrade.objectForKey("rates") as! NSDictionary
        var secondRates: NSDictionary = secondGrade.objectForKey("rates") as! NSDictionary
    
        // Create variables for all view controllers you want to put in the
        // page menu, initialize them, and add each to the controller array.
        // (Can be any UIViewController subclass)
        // Make sure the title property of all view controllers is set
        var controllerArray : [UIViewController] = []
        
        
        if  firstRates.objectForKey("status") as! String == "available" && secondRates.objectForKey("status") as! String == "available"{
            
            var evasionChart = self.setupGraph(firstRates.objectForKey("evasion") as! NSArray, y2Values: secondRates.objectForKey("evasion") as! NSArray,graphTitleString: "Evasão", graphDescription: " O Índice de Evasão retrata o percentual de alunos que deixaram de frequentar a escola, caracterizando dessa forma abandono escolar. Tal índice é obtido por meio do Censo Escolar pelo Inep e compõe o Índice de Desenvolvimento da Educação Brasileira (Ideb).")
            
            var peformanceChart = self.setupGraph(firstRates.objectForKey("performance") as! NSArray, y2Values:secondRates.objectForKey("performance") as! NSArray, graphTitleString: "Rendimento", graphDescription: " O Índice de Evasão retrata o percentual de alunos que deixaram de frequentar a escola, caracterizando dessa forma abandono escolar. Tal índice é obtido por meio do Censo Escolar pelo Inep e compõe o Índice de Desenvolvimento da Educação Brasileira (Ideb).")
            
            var distortionChart = self.setupGraph(firstRates.objectForKey("distortion") as! NSArray, y2Values:secondRates.objectForKey("distortion") as! NSArray,graphTitleString: "Distorção", graphDescription: " O Índice de Evasão retrata o percentual de alunos que deixaram de frequentar a escola, caracterizando dessa forma abandono escolar. Tal índice é obtido por meio do Censo Escolar pelo Inep e compõe o Índice de Desenvolvimento da Educação Brasileira (Ideb).")
            
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
        self.newCompare.hidden = false
        self.firstPicker.hidden = true
        self.secondPicker.hidden = true
    }
    
    func setupGraph(y1Valeus : NSArray, y2Values : NSArray,graphTitleString : String, graphDescription : String) -> EnTurmaLineChartView{
        
        let chartViewFrame = CGRectMake(0, 10, view.bounds.width, self.view.bounds.width)
        
        var initialGrade = self.json.objectForKey("first_report")?.objectForKey("grade") as! Int
        var firstSampleData = self.json.objectForKey("first_report")?.objectForKey("rates")?.objectForKey("evasion") as! NSArray
        
        var secondSampleData = self.json.objectForKey("second_report")?.objectForKey("rates")?.objectForKey("evasion") as! NSArray
        
        var numberOfPoints = 0
        
        if firstSampleData.count >= secondSampleData.count{
            numberOfPoints = firstSampleData.count
        }else{
            numberOfPoints = secondSampleData.count
        }
        
        var xValues:[String] = []
        
        for i in initialGrade...(initialGrade+numberOfPoints-1){
            xValues.append("\(i) ano")
        }
        
        var newChart = EnTurmaLineChartView(frame: chartViewFrame, xValues: xValues, y1Values: y1Valeus, y2Values: y2Values, graphTitleString: graphTitleString, graphTextDescription: graphDescription)
        
        newChart.animate(yAxisDuration: 2.0)
        return newChart
    }
    
    func createViewController(title:String, graph : EnTurmaLineChartView) -> UIViewController{
        var controller : UIViewController = UIViewController()
        controller.title = title
        controller.view.addSubview(graph)
        return controller
    }

    
    
    
    func titleForItemSelected(pickerView: UIPickerView,componet: Int) -> String{
        var title = self.pickerView(pickerView, titleForRow: pickerView.selectedRowInComponent(componet), forComponent: componet)
        return title
    }

    @IBAction func newCompare(sender: AnyObject) {
        self.pageMenu!.view.removeFromSuperview()
        self.newCompare.hidden = true
        self.firstPicker.hidden = false
        self.secondPicker.hidden = false
    }
    
}
