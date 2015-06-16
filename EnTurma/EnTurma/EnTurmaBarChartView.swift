//
//  SingleLineChartView.swift
//
//
//  Created by Thiago-Bernardes on 6/11/15.
//
//

import UIKit
import Charts

class EnTurmaBarChartView: BarChartView, ChartViewDelegate{
    
    var valueLabel1: UILabel!
    var valueLabel2: UILabel!
    var yValues1: NSArray!
    var yValues2: NSArray!
    var graphTitle: String!
    var graphDescriptionString: String!

    
    init(singleBarGraphframe: CGRect, xValues: NSArray, yValues: NSArray, graphTitleString: String, graphTextDescription: String) {
        super.init(frame: singleBarGraphframe)
        
        graphTitle = graphTitleString
        graphDescriptionString = graphTextDescription
        setupGraph()
        
        yValues1 = yValues
        setSingleBarChartData(xValues, yValues: yValues)
        
        setVisibleXRangeMinimum(CGFloat(xValues.count-1))
        
    }
    
    
    init(doubleBarGraphframe: CGRect, xValues: NSArray, y1Values: NSArray, y2Values: NSArray, graphTitleString: String, graphTextDescription: String) {
        
        super.init(frame: doubleBarGraphframe)

        graphTitle = graphTitleString
        graphDescriptionString = graphTextDescription
        
        setupGraph()
        
        yValues1 = y1Values
        yValues2 = y2Values
        setTwoBarsChartData(xValues, y1Values: yValues1, y2Values: yValues2)
        
        setVisibleXRangeMinimum(CGFloat(xValues.count-1))
        
        
    }
    
    
    
    
    func setupGraph(){
        delegate = self
        descriptionText = ""
        noDataTextDescription = "O grafico precisa de dados"
        
        highlightEnabled = true
        dragEnabled = true
        //true motherfoca
        doubleTapToZoomEnabled = false
        scaleXEnabled = false
        pinchZoomEnabled = false
        setScaleEnabled(false)
        drawGridBackgroundEnabled = false
        
        xAxis.enabled = true
        xAxis.labelPosition = ChartXAxis.XAxisLabelPosition.Bottom
        xAxis.labelFont = UIFont(name: "HelveticaNeue-Bold", size: 8)!
        xAxis.labelTextColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
        xAxis.axisLineColor = UIColor(white: 0, alpha: 0)
        xAxis.labelWidth = 2
        xAxis.drawGridLinesEnabled = false
        
        leftAxis.enabled = true
        leftAxis.startAtZeroEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.drawLimitLinesBehindDataEnabled = true
        leftAxis.labelFont = UIFont(name: "HelveticaNeue-Bold", size: 8)!
        leftAxis.labelTextColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
        leftAxis.axisLineColor = UIColor(white: 0, alpha: 0)
        
        
        
        rightAxis.enabled = false
        legend.position = ChartLegend.ChartLegendPosition.BelowChartCenter
        legend.font = UIFont(name: "HelveticaNeue-Bold", size: 15)!
        legend.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
        legend.form = ChartLegend.ChartLegendForm.Square
        
        valueFormatter = NSNumberFormatter()
        valueFormatter.maximumFractionDigits = 1;
        
        let descriptionButtonFrame = CGRectMake(0, 0 , bounds.width, 25)
        let descriptionButton = UIButton(frame: descriptionButtonFrame)
        descriptionButton.titleLabel!.textAlignment = .Center
        descriptionButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 25)!
        descriptionButton.setTitle(graphTitle, forState: .Normal)
        descriptionButton.setTitleColor(
            UIColor(
            red: 128/255,
            green: 128/255,
            blue: 128/255,
            alpha: 1)
,
            forState: .Normal)
        descriptionButton.setImage(UIImage(named: "infoButton"), forState: .Normal)
        descriptionButton.addTarget(self, action: "showGraphDescription:", forControlEvents: .TouchUpInside)
        addSubview(descriptionButton);

        
        
    }
    
    func showGraphDescription(sender: UIButton!){
        
        var textContainer = NSTextContainer(size: CGSize(width: window!.frame.width, height: window!.frame.height))

        var descriptionView = GraphDescriptionView(frame: window!.frame, descriptionText: graphDescriptionString)
        
        var visualEffect = UIBlurEffect(style:.Light)
        var visualEffectView = UIVisualEffectView(effect: visualEffect)
        visualEffectView.frame = window!.frame
        
        
    
        UIView.transitionWithView(window!, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            // remove the front object...
            
            // ... and add the other object
            self.window?.addSubview(visualEffectView)
            visualEffectView.addSubview(descriptionView)
            
            }, completion: { finished in
                // any code entered here will be applied
                // .once the animation has completed
        })
        
    }
    
       
    func setSingleBarChartData(xValues: NSArray, yValues: NSArray){
        
        var convertedYVals1 = convertDataToChartData(yValues)
        
        let dataSet1 = BarChartDataSet(yVals: convertedYVals1 as? [BarChartDataEntry], label: "Turma1")
        
        dataSet1.setColor(UIColor.blueColor())
        
        var barChartData = BarChartData(xVals: xValues as? [NSObject], dataSet: dataSet1 as BarChartDataSet)
        
        barChartData.groupSpace = 0.5
        barChartData.setValueFont(UIFont(name: "HelveticaNeue-Light",size:10.0))
        
        data = barChartData
    }
    
    func setTwoBarsChartData(xValues: NSArray, y1Values: NSArray, y2Values: NSArray){
        
        var convertedYVals1 = convertDataToChartData(yValues1)
        var convertedYVals2 = convertDataToChartData(yValues2)
        
        
        let dataSet1 = BarChartDataSet(yVals: convertedYVals1 as? [BarChartDataEntry], label: "Turma1")
        dataSet1.setColor(UIColor.blueColor())
        
        let dataSet2 = BarChartDataSet(yVals: convertedYVals2 as? [BarChartDataEntry], label: "Turma2")
        dataSet2.setColor(UIColor.redColor())
        
        var dataSets = NSArray(objects: dataSet1,dataSet2)
        
        var barChartData = BarChartData(xVals: xValues as? [NSObject], dataSets: dataSets as? [BarChartDataSet])
        
        barChartData.groupSpace = 0.5
        barChartData.setValueFont(UIFont(name: "HelveticaNeue-Light",size:10.0))
        
        data = barChartData

        
    }
    
    
    func convertDataToChartData(data: NSArray) -> NSArray{
        
        var chartDataSet = NSMutableArray()
        
        for index in 0...data.count-1{
            
            var value = data.objectAtIndex(index) as! Double
            var chartDataEntry = BarChartDataEntry(value: value, xIndex: index)
            chartDataSet.addObject(chartDataEntry)
        }
        
        return chartDataSet
        
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        
        UIView.animateWithDuration(1.0, animations: {
            
            if((self.valueLabel1) != nil){
                self.valueLabel1.alpha = 0
                
            }
            if((self.valueLabel2) != nil){
                self.valueLabel2.alpha = 0
                
            }
            
        });
        
        
        UIView.animateWithDuration(1.0, animations: {
            
            if((self.valueLabel1) != nil){
                var valueLabel1Text = String.localizedStringWithFormat("%.1f %%", self.yValues1.objectAtIndex(entry.xIndex) as! Double )
                
                self.valueLabel1.text = valueLabel1Text
                self.valueLabel1.alpha = 1
                
                
            }
            
            if((self.valueLabel2) != nil){
                
                var valueLabel2Text = String.localizedStringWithFormat("%.1f %%", self.yValues2.objectAtIndex(entry.xIndex) as! Double )
                self.valueLabel2.text = valueLabel2Text
                self.valueLabel2.alpha = 1
                
            }
            
            
        });
        
        
        NSLog(" chart value selected")
    }
    
    func chartValueNothingSelected(chartView: ChartViewBase) {
        NSLog("Nothing selected")
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
