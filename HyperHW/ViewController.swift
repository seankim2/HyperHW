//
//  ViewController.swift
//  HyperHW
//
//  Created by khkim2 on 18/06/2019.
//  Copyright © 2019 khkim2. All rights reserved.
//

/********************************************************************
 Declare import framework
 ********************************************************************/
import UIKit

/********************************************************************
 UIDevice extention
 ********************************************************************/
extension UIDevice {
    var hasNotch: Bool {
        var bottom = 0
        if #available(iOS 11.0, *) {
            bottom = Int(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
        } else {
            // Fallback on earlier versions
        }
        return bottom > 0
    }
}

/********************************************************************
 Declare Class
 ********************************************************************/
class ViewController: UIViewController {
    
    /********************************************************************
     IBOutlet Objects
     ********************************************************************/
    @IBOutlet weak var slideLbl: UILabel!
    @IBOutlet weak var timePeriodSldr: UISlider!
    @IBOutlet weak var timePeriodLbl: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    
    /********************************************************************
     ViewController life cycle
     ********************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.openSlideShowVC), name: NSNotification.Name(rawValue: "openSlideShowVC"), object: nil)
        
        self.drawComponentsUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.drawTimePeriod(value: CommonComponents.timeSlideValue)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /********************************************************************
     About Rotate
     ********************************************************************/
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown, .landscapeLeft, .landscapeRight]
    }
    
    @objc func openSlideShowVC() {
        performSegue(withIdentifier: "openSlideShowVC", sender: nil)
    }
    
    /********************************************************************
     * Name           : drawComponentsUI
     * Description    : Draw components for UI
     * Arguments      : Void
     * Returns        : Void
     ********************************************************************/
    func drawComponentsUI() {
        self.slideLbl.textColor = CommonComponents.sharedInstance?.titleColor
        
        self.startBtn?.setTitleColor(CommonComponents.sharedInstance?.titleColor, for: .normal)
        self.startBtn?.backgroundColor = UIColor.white
        self.startBtn?.layer.cornerRadius = 5
        self.startBtn?.layer.borderWidth = 1
        self.startBtn?.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    /********************************************************************
     * Name           : drawTimePeriod
     * Description    : Draw time period
     * Arguments      : value -> value for drawing lable, slider
     * Returns        : Void
     ********************************************************************/
    func drawTimePeriod(value: Float) {
        let curSecVal = Int(value)
        //print("\(#function) curSecVal : \(curSecVal)")
        self.timePeriodLbl.text = "\(curSecVal) 초"
        
        // for sharing between ViewController and SlideShowViewController
        CommonComponents.timeSlideValue = value
        self.timePeriodSldr.value = value
    }
    
    /********************************************************************
     IBAction Process
     ********************************************************************/
    @IBAction func processTimePeriodSlider(_ sender: Any) {
        self.drawTimePeriod(value: self.timePeriodSldr.value)
    }
    
    @IBAction func processStartBtn(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openSlideShowVC"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
