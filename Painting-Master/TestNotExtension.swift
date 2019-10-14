//
//  TestNotExtension.swift
//  Painting-Master
//
//  Created by RTC-HN154 on 10/14/19.
//  Copyright © 2019 RTC-HN154. All rights reserved.
//

import UIKit

class ViewController1: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var mainView: UIImageView!
    
    var lastPoint = CGPoint.zero
    var red : CGFloat = 0.0
    var green : CGFloat = 0.0
    var blue : CGFloat = 0.0
    var brushWidth : CGFloat = 10.0
    var opacity : CGFloat = 1.0
    var swiped = false
    var baseImage = UIImage()
    var brush : String!
    
    let imgColors = ["Black", "Grey", "Red", "Blue", "LightBlue", "DarkGreen", "LightGreen", "Brown", "DarkOrange", "Yellow"]
    
    let colors : [(CGFloat, CGFloat, CGFloat)] = [
        (0, 0, 0),
        (105.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0),
        (1.0, 0, 0),
        (0, 0, 1.0),
        (51.0 / 255.0, 204.0 / 255.0, 1.0),
        (102.0 / 255.0, 204.0 / 255.0, 0),
        (102.0 / 255.0, 1.0, 0),
        (160.0 / 255.0, 82.0 / 255.0, 45.0 / 255.0),
        (1.0, 102.0 / 255.0, 0),
        (1.0, 1.0, 0),
        (1.0, 1.0, 1.0),
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func action_reset(_ sender: Any) {
        mainView.image = baseImage
    }
    
    @IBAction func action_Album(_ sender: Any) {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imgPicker, animated: true, completion: nil)
    }
    
    @IBAction func action_Save(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(mainView.image!, self, nil, nil)
    }
    
    @IBAction func action_Click(_ sender: UIButton) {
        let index = sender.tag
        switch index {
        case 0 : brushWidth = 5
        case 1 : brushWidth = 10
        case 2 : brushWidth = 30
        case 3 : (red, green, blue) = colors[10]
        default : break
        }
    }
    
    @IBAction func action_Brush(_ sender: UIButton) {
        let index = sender.tag
        switch index {
        case 4 : brush = "round"
        case 5 : brush = "square"
        case 6 : brush = "butt"
        default: brush = "round"
        }
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage : UIImage = (info[.originalImage] as? UIImage) {
            baseImage = pickedImage
            mainView.image = baseImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        
        if let touches = touches.first {
            lastPoint = touches.location(in: view)
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        
        if let touch = touches.first {
            let currentPoint = touch.location(in: mainView)
            
            drawLine(fromPoint: lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!swiped) {
            drawLine(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }
    
    func drawLine(fromPoint : CGPoint, toPoint : CGPoint) {
        UIGraphicsBeginImageContext(mainView.frame.size)
        let contex = UIGraphicsGetCurrentContext()
        mainView.image?.draw(in: CGRect(x: 0, y: 0, width: mainView.frame.size.width, height: mainView.frame.size.height))
        
        contex?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        contex?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        if (brush == "round") {
            contex?.setLineCap(CGLineCap.round)
        }
        if (brush == "square") {
            contex?.setLineCap(CGLineCap.square)
        }
        if (brush == "butt") {
            contex?.setLineCap(CGLineCap.butt)
        }

        contex?.setLineWidth(brushWidth)
        contex?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        contex?.setBlendMode(CGBlendMode.normal)
        
        contex?.strokePath()
        mainView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        mainView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCell
        cell.imgView.image = UIImage(named: imgColors[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (red, green, blue) = colors[indexPath.item]
    }
    
}

