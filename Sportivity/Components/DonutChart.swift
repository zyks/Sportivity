//
//  DonutChart.swift
//  Sportivity
//
//  Created by Paweł Zykowski on 15.05.2016.
//  Copyright © 2016 Paweł Zykowski. All rights reserved.
//


import UIKit


class DonutChart : UIScrollView, DonutViewDataSource, ListViewDataSource {
    
    var dataSource: DonutChartDataSource?
    var data: [String: Double] = [String: Double]()
    var valuesSum: Double = 0.0
    var colors: [UIColor] = [UIColor]()
    var imageView = UIImageView()
    let donutWidth: CGFloat = 50
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        self.data = self.dataSource!.dataForDonutChart()
        guard self.data.count > 0 else { return }
        self.colors = self.generateColors(self.data.count)
        self.valuesSum = self.data.values.reduce(0, combine: +)
        
        self.contentSize = CGSize(
            width: bounds.width,
            height: bounds.width + CGFloat((self.data.count + 1) * 40) + 10
        )
        self.addDonutView()
        self.addListView()
        self.addImageView()
    }
    
    func addDonutView() {
        let donutView = DonutView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: bounds.width,
                height: bounds.width
            )
        )
        donutView.dataSource = self
        addSubview(donutView)
    }
    
    func addListView() {
        let listView = ListView(
            frame: CGRect(
                x: 0,
                y: bounds.width + 10,
                width: bounds.width,
                height: CGFloat((self.data.count + 1) * 40)
            )
        )
        listView.dataSource = self
        addSubview(listView)
    }
    
    func addImageView() {
        let radius: CGFloat = bounds.width * 0.9 / 2
        let imageSize = (radius - self.donutWidth) * 2 - 5
        
        imageView.frame = CGRect(
            x: bounds.width/2 - imageSize/2,
            y: bounds.width/2 - imageSize/2,
            width: imageSize,
            height: imageSize
        )
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.layer.masksToBounds = true
        
        addSubview(imageView)
    }
    
    func generateColors(number: Int) -> [UIColor] {
        var colors = [UIColor]()
        for i in 0..<number {
            let newColor = UIColor.init(hue: CGFloat(i) / CGFloat(number), saturation: 0.4, brightness: 0.9, alpha: 1.0)
            colors.append(newColor)
        }
        return colors
    }
    
    func dataForDonutView() -> [String : Double] {
        return self.data
    }
    
    func dataForListView() -> [String : Double] {
        return self.data
    }
    
    func colorsForDonutView() -> [UIColor] {
        return self.colors
    }

    func colorsForListView() -> [UIColor] {
        return self.colors
    }
    
}


class DonutView : UIView {
    
    var dataSource: DonutViewDataSource?
    var donutWidth: CGFloat = 50

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
    }
    
    override func drawRect(rect: CGRect) {
        guard self.dataSource != nil else {
            return
        }
        
        let center = CGPoint(x: bounds.width/2, y: bounds.width/2)
        let radius: CGFloat = bounds.width * 0.9 / 2
        var prefixSum = 0.0
        let data = self.dataSource!.dataForDonutView()
        let colors = self.dataSource!.colorsForDonutView()
        let valuesSum = data.values.reduce(0, combine: +)
        
        for (i, (_, value)) in data.enumerate() {
            let startAngle: CGFloat = CGFloat(prefixSum * 2 * M_PI / valuesSum)
            let endAngle: CGFloat = CGFloat((prefixSum + value) * 2 * M_PI / valuesSum)
            prefixSum += value
            
            let path = UIBezierPath(
                arcCenter: center,
                radius: radius - self.donutWidth/2.0,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: true
            )
            path.lineWidth = self.donutWidth
            colors[i].setStroke()
            
            path.stroke()
        }
    }

}


class ListView : UIView {
    
    var dataSource: ListViewDataSource?
    var rectSize: CGFloat = 30
    var interspace: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
    }
    
    override func drawRect(rect: CGRect) {
        guard self.dataSource != nil else {
            return
        }
        
        let data = self.dataSource!.dataForListView()
        let colors = self.dataSource!.colorsForListView()
        let valuesSum = data.values.reduce(0, combine: +)
        
        for (i, (name, value)) in data.enumerate() {
            let rect = CGRect(x: 20, y: 10+CGFloat(CGFloat(i)*(self.rectSize+self.interspace)), width: self.rectSize, height: self.rectSize)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: 5)
            colors[i].setFill()
            path.fill()
            
            let rect2 = CGRect(x: 10+self.rectSize*2, y: 10+CGFloat(CGFloat(i)*(self.rectSize+self.interspace)), width: 200, height: self.rectSize)
            let label = UILabel(frame: rect2)
            let percent = String(format: "%.1f", value / valuesSum * 100)
            label.text = "\(name): \(percent)%"
            addSubview(label)
        }
    }
}


protocol DonutChartDataSource {
    
    func dataForDonutChart() -> [String: Double]
//    func imageForDonutChart() -> UIImage? {
//        return nil
//    }
}


protocol DonutViewDataSource {
    
    func dataForDonutView() -> [String: Double]
    func colorsForDonutView() -> [UIColor]
}


protocol ListViewDataSource {
    
    func dataForListView() -> [String: Double]
    func colorsForListView() -> [UIColor]
}

