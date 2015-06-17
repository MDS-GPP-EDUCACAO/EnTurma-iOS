//
//  ReportViewController.swift
//  EnTurma
//
//  Created by Gabriel Silva on 6/16/15.
//  Copyright (c) 2015 mds. All rights reserved.
//

import UIKit
import Alamofire

class ReportViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var mainPickeView: UIPickerView!
    @IBOutlet weak var network: UIPickerView!
    @IBOutlet weak var local: UIPickerView!
    @IBOutlet weak var newReport: UIButton!
    
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
        self.newReport.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - PickerView  delegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        var numberOfComponets = 0;
        
        switch pickerView.tag {
            case 0:
                numberOfComponets = 3
            default:
                numberOfComponets = 1
        }
        return numberOfComponets
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var numberOfRows = 0
        
        if pickerView.tag == 0{
            switch component{
                case 0:
                    numberOfRows = (optionsForSelect.objectForKey("state") as! NSArray).count
                case 1:
                    numberOfRows = (optionsForSelect.objectForKey("grades") as! NSArray).count
                case 2:
                    numberOfRows = (optionsForSelect.objectForKey("years") as! NSArray).count
                default:
                    numberOfRows = 0
            }
        }else if pickerView.tag == 1{
            numberOfRows = (optionsForSelect.objectForKey("network") as! NSArray).count
        }else if pickerView.tag == 2{
            numberOfRows = (optionsForSelect.objectForKey("local") as! NSArray).count
        }
        
        return numberOfRows
    }
    
    // MARK: - PickerView  Data Source
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        var title = ""
        
        if pickerView.tag == 0{
        switch component{
            case 0:
                title = (optionsForSelect.objectForKey("state") as! NSArray).objectAtIndex(row) as! String
            case 1:
                title = (optionsForSelect.objectForKey("grades") as! NSArray).objectAtIndex(row) as! String
            case 2:
                title = (optionsForSelect.objectForKey("years") as! NSArray).objectAtIndex(row) as! String
            default:
                title = ""
            }
        }else if pickerView.tag == 1{
            title = (optionsForSelect.objectForKey("network") as! NSArray).objectAtIndex(row) as! String
        }else if pickerView.tag == 2{
            title = (optionsForSelect.objectForKey("local") as! NSArray).objectAtIndex(row) as! String
        }
        return title
    }
    
    @IBAction func requestReport(sender: AnyObject) {
        self.prepareParams()
    }
    
    private func prepareParams(){
        //request Rest
        var year = self.titleForItemSelected(self.mainPickeView, componet: 2)
        var grade = self.titleForItemSelected(self.mainPickeView, componet: 1)
        var state = self.titleForItemSelected(self.mainPickeView, componet: 0)
        var network = self.titleForItemSelected(self.network, componet: 0)
        var local = self.titleForItemSelected(self.local, componet: 0)
        
        var params = ["year":year, "grade":grade, "state":state, "test_type":network, "local":local,"public_type": "Total"]

        var rest = RESTFullManager(params: params)
        rest.requestReport({ (jsonObject) -> Void in
            self.plotData(jsonObject)
        }, failure: { () -> Void in
            
        })
    }
    
    
    func titleForItemSelected(pickerView: UIPickerView,componet: Int) -> String{
        var title = self.pickerView(pickerView, titleForRow: pickerView.selectedRowInComponent(componet), forComponent: componet)
        return title
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
        self.newReport.hidden = false
        self.mainPickeView.hidden = true
        self.network.hidden = true
        self.local.hidden = true
    }
    
    func setupGraph(yValeus : NSArray, graphTitleString : String, graphDescription : String) -> EnTurmaLineChartView{
        
        let chartViewFrame = CGRectMake(0, 10, view.bounds.width, self.view.bounds.width)
        
        var initialYear = self.titleForItemSelected(self.mainPickeView, componet: 2).toInt()!
        
        var xValues:[String] = []
        
        for i in initialYear...2013{
            xValues.append("\(i)")
        }
        
        var newChart = EnTurmaLineChartView(frame: chartViewFrame, xValues: xValues, yValues: yValeus, graphTitleString: graphTitleString, graphTextDescription: graphDescription)
    
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
        self.newReport.hidden = true
        self.mainPickeView.hidden = false
        self.network.hidden = false
        self.local.hidden = false
    }
}
