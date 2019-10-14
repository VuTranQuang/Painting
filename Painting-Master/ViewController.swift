//
//  ViewController.swift
//  Painting-Master
//
//  Created by RTC-HN154 on 10/14/19.
//  Copyright © 2019 RTC-HN154. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
    }
    
    @IBAction func onClickReset(_ sender: UIBarButtonItem) {
        mainView.image = baseImage
    }
    
    @IBAction func onClickAlbum(_ sender: UIBarButtonItem) {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.sourceType = .photoLibrary
        self.present(imgPicker, animated: true, completion: nil)
    }
    
    @IBAction func onClickSave(_ sender: UIBarButtonItem) {
        UIImageWriteToSavedPhotosAlbum(mainView.image!, self, nil, nil)
    }
    
    @IBAction func onClickPxButton(_ sender: UIButton) {        // Các kích thước của bút vẽ
        let index = sender.tag
        switch index {
        case 0:
            brushWidth = 5
        case 1:
            brushWidth = 10
        case 2:
            brushWidth = 30
        case 3:
            (red, green, blue) = colors[10]     // Bút tẩy
        default:
            break
        }
    }
    
    @IBAction func onClickTypePaint(_ sender: UIButton) {       // Trọn kiểu nét vẽ với các type khác nhau.
        let index = sender.tag
        switch index {
        case 4:
            brush = "round"
        case 5:
            brush = "square"
        case 6:
            brush = "butt"
        default:
            brush = "round"
        }
    }
    
    // Bắt đầu nét vẽ
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touche = touches.first {
            lastPoint = touche.location(in: view)
        }
    }
    
    
    // Đang vẽ
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touche = touches.first {
            let currentPoint = touche.location(in: mainView)
            
           drawLine(fromPoint: lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    // Dừng vẽ và bắt trường hợp như người dùng chỉ click vào màn hình tại 1 điểm
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            drawLine(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }
    
    
    // MARK: Hàm để vẽ
    func drawLine(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(mainView.frame.size)
        
        let context = UIGraphicsGetCurrentContext()
        mainView.image?.draw(in: CGRect(x: 0, y: 0, width: mainView.frame.width, height: mainView.frame.height)) // Vùng có thể vẽ
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        // các dạng nét vẽ
        if brush == "round" {           // nét liền
            context?.setLineCap(.round)
        }
        if brush == "Square" {              // nét đứt
            context?.setLineCap(.square)
        }
        if brush == "butt" {                    // nét đứt nhiều
            context?.setLineCap(.butt)
        }
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context?.setBlendMode(.normal)
        
        context?.strokePath()
        mainView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()         // gọi ra để dừng hàm vẽ lại, như kiểu deinit
    }
    


}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage : UIImage = (info[.originalImage] as? UIImage) {
            baseImage = pickedImage
            mainView.image = baseImage
        }
        self.dismiss(animated: true, completion: nil)
    }
}
