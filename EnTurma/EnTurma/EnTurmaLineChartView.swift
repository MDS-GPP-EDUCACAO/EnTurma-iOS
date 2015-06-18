//
//  SingleLineChartView.swift
//
//
//  Created by Thiago-Bernardes on 6/11/15.
//
//

import UIKit
import Charts

class EnTurmaLineChartView: LineChartView, ChartViewDelegate{
    
    var valueLabel1: UILabel!
    var valueLabel2: UILabel!
    var yValues1: NSArray!
    var yValues2: NSArray!
    var graphTitle: String!
    var graphDescriptionString: String!

    
    init(singleLineGraphframe: CGRect, xValues: NSArray, yValues: NSArray, graphTitleString: String, graphTextDescription: String) {
        super.init(frame: singleLineGraphframe)
        
        graphTitle = graphTitleString
        graphDescriptionString = graphTextDescription
        setupGraph()
        
        yValues1 = yValues
        setSingleLineChartData(xValues, yValues: yValues)
        
        setVisibleXRangeMinimum(CGFloat(xValues.count-1))
        
    }
    
    
    init(doubleLineGraphframe: CGRect, xValues: NSArray, y1Values: NSArray, y2Values: NSArray, graphTitleString: String, graphTextDescription: String) {
        
        super.init(frame: doubleLineGraphframe)
        
        graphTitle = graphTitleString
        graphDescriptionString = graphTextDescription

        setupGraph()
        
        yValues1 = y1Values
        yValues2 = y2Values
        setTwoLinesChartData(xValues, y1Values: y1Values, y2Values: y2Values)
        
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
        legend.form = ChartLegend.ChartLegendForm.Line
        
        
        let descriptionButtonFrame = CGRectMake(0,-10 , bounds.width, 25)
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
    
       
    func setSingleLineChartData(xValues: NSArray, yValues: NSArray){
        
        var chartDataSet = convertDataToChartData(yValues)
        
        let dataSet1 = LineChartDataSet(yVals: chartDataSet as? [ChartDataEntry], label: "Índice em porcentagem")
        dataSet1.drawCubicEnabled = true
        dataSet1.cubicIntensity = 0.2
        dataSet1.drawCirclesEnabled = true
        dataSet1.drawCircleHoleEnabled = false
        dataSet1.circleColors = [UIColor.blueColor()]
        dataSet1.lineWidth = 3.0
        dataSet1.circleRadius = 5.0
        dataSet1.highlightColor = UIColor.blueColor()
        dataSet1.setColor(UIColor.blueColor())
        dataSet1.fillColor = UIColor.blueColor()
        dataSet1.fillAlpha = 0.2
        dataSet1.drawFilledEnabled = true
        dataSet1.drawValuesEnabled = false
        
        
        var chartData = LineChartData(xVals: xValues as? [NSObject], dataSet: dataSet1)
        legend.enabled = true
        
        let labelFrame1 = CGRectMake(0, frame.height - 5 , frame.width, 15)
        valueLabel1 = UILabel(frame: labelFrame1)
        valueLabel1.textAlignment = .Center
        valueLabel1.font = UIFont(name: "HelveticaNeue-Bold", size: 15)!
        valueLabel1.text = ""
        addSubview(valueLabel1);
        
        data = chartData
        
    }
    
    func setTwoLinesChartData(xValues: NSArray, y1Values: NSArray, y2Values: NSArray){
        
        var chartDataSet1 = convertDataToChartData(y1Values)
        
        var chartDataSet2 = convertDataToChartData(y2Values)
        
        let dataSet1 = LineChartDataSet(yVals: chartDataSet1 as? [ChartDataEntry], label: "Turma 1")
        let dataSet2 = LineChartDataSet(yVals: chartDataSet2 as? [ChartDataEntry], label: "Turma 2")
        
        dataSet1.drawCubicEnabled = true
        dataSet1.cubicIntensity = 0.2
        dataSet1.drawCirclesEnabled = true
        dataSet1.drawCircleHoleEnabled = false
        dataSet1.circleColors = [UIColor.blueColor()]
        dataSet1.lineWidth = 3.0
        dataSet1.circleRadius = 5.0
        dataSet1.highlightColor = UIColor.blueColor()
        dataSet1.setColor(UIColor.blueColor())
        dataSet1.fillColor = UIColor.blueColor()
        dataSet1.fillAlpha = 0.2
        dataSet1.drawFilledEnabled = true
        dataSet1.drawValuesEnabled = false
        
        dataSet2.drawCubicEnabled = true
        dataSet2.cubicIntensity = 0.2
        dataSet2.drawCirclesEnabled = true
        dataSet2.circleColors = [UIColor.redColor()]
        dataSet2.drawCircleHoleEnabled = false
        dataSet2.lineWidth = 3.0
        dataSet2.circleRadius = 5.0
        dataSet2.highlightColor = UIColor.redColor()
        dataSet2.setColor(UIColor.redColor())
        dataSet2.fillColor = UIColor.redColor()
        dataSet2.fillAlpha = 0.2
        dataSet2.drawFilledEnabled = true
        dataSet2.drawValuesEnabled = false
        
        var chartData = LineChartData(xVals: xValues as? [NSObject], dataSets: [dataSet1, dataSet2])
        
        
        
        let labelFrame1 = CGRectMake(center.x - 45, frame.height - 5 , frame.width/2, 15)
        valueLabel1 = UILabel(frame: labelFrame1)
        valueLabel1.font = UIFont(name: "HelveticaNeue-Bold", size: 15)!
        
        valueLabel1.text = ""
        
        let labelFrame2 = CGRectMake(center.x + 30, frame.height - 5 , frame.width/2, 15)
        valueLabel2 = UILabel(frame: labelFrame2)
        valueLabel2.font = UIFont(name: "HelveticaNeue-Bold", size: 15)!
        valueLabel2.text = ""
        
        addSubview(valueLabel1);
        addSubview(valueLabel2);
        
        legend.enabled = true
        
        data = chartData
        
    }
    
    
    func convertDataToChartData(data: NSArray) -> NSArray{
        
        var chartDataSet = NSMutableArray()
        
        for index in 0...data.count-1{
            
            var value = data.objectAtIndex(index) as! Double
            var chartDataEntry = ChartDataEntry(value: value, xIndex: index)
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
        
        
    }
    
    func chartValueNothingSelected(chartView: ChartViewBase) {
    }
    
    override func didMoveToWindow() {
        animate(yAxisDuration: 2.0)

    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
