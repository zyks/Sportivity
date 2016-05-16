//
//  DonutChart.swift
//  Sportivity
//
//  Created by Paweł Zykowski on 15.05.2016.
//  Copyright © 2016 Paweł Zykowski. All rights reserved.
//


import UIKit


class UserView : UIScrollView {
    
    var donutWidth: CGFloat = 50
    var cellHeight: CGFloat = 30
    var interspace: CGFloat = 10

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func adjustContentSize(elements: Int) {
        self.contentSize = CGSize(
            width: bounds.width,
            height: bounds.width + CGFloat(elements) * (self.cellHeight + self.interspace)
        )
    }
    
    func addDonutView(dataSource: DonutChartViewDataSource) {
        let donutView = DonutChartView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: bounds.width,
                height: bounds.width
            )
        )
        donutView.donutWidth = self.donutWidth
        donutView.dataSource = dataSource
        addSubview(donutView)
    }
    
    func addListView(dataSource: ListViewDataSource) {
        let listView = ListView(
            frame: CGRect(
                x: 0,
                y: bounds.width + self.interspace,
                width: bounds.width,
                height: CGFloat((dataSource.dataForListView().count + 1)) * (self.cellHeight + self.interspace)
            )
        )
        listView.cellHeight = self.cellHeight
        listView.interspace = self.interspace
        listView.dataSource = dataSource
        addSubview(listView)
    }
    
    func addImageView(image: UIImage) {
        let radius: CGFloat = bounds.width * 0.85 / 2
        let imageSize = (radius - self.donutWidth) * 2 - 5
        
        let imageView = UIImageView(image: image)
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
    
}



