//
//  SlideShowViewController.swift
//  HyperHW
//
//  Created by khkim2 on 20/06/2019.
//  Copyright © 2019 khkim2. All rights reserved.
//

/********************************************************************
 Declare import framework
 ********************************************************************/
import Foundation
import UIKit
import Alamofire
import SDWebImage

/********************************************************************
 Declare Class
 ********************************************************************/
class SlideShowViewController: UIViewController {

    /********************************************************************
     Variables
     ********************************************************************/
    var canGetImage: Bool = true           // whether new images gets
    var isDrawImage: Bool = false          // flickrImgArr has no data
    var count: Int = 0                     // flickrImgArr Number
    var index: Int = 0                     // flickrImgArr index
    let showTime: Double = 2.0
    let hideTime: Double = 2.0
    var stopDrawImg: Bool = false
    var flickrImgArr: [String] = []        // Image Array of Flickr
    let serverURL = "https://api.flickr.com/services/feeds/photos_public.gne?tags=landscape,portrait&tagmode=any&format=json&nojsoncallback=1"
    
    /********************************************************************
     About Indicator
     ********************************************************************/
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    let loadingContainer: UIView = UIView()
    
    /********************************************************************
     IBOutlet Objects
     ********************************************************************/
    @IBOutlet weak var flickrIV: UIImageView!
    @IBOutlet weak var timePeriodSldr: UISlider!
    @IBOutlet weak var timePeriodLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!

    /********************************************************************
     ViewController life cycle
     ********************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.drawComponentsUI()
        self.drawFlickrImages(showFunc: showFadeIn, hideFunc: hideFadeOut)
        
        if UIDevice.current.hasNotch {
            backBtn.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: 5).isActive = true
        } else {
            print("[\(#function)] don't have to consider notch")
            backBtn.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -5).isActive = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        stopDrawImg = false
        self.drawTimePeriod(value: CommonComponents.timeSlideValue)
        
        //ask the system to start notifying when interface change
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationChanged(notification:)),
            name: UIDevice.orientationDidChangeNotification,
            object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopDrawImg = true
        NotificationCenter.default.removeObserver(self,
                                                  name: UIDevice.orientationDidChangeNotification,
                                                  object: nil)
    }
    
    /********************************************************************
     IBAction Process
     ********************************************************************/
    @IBAction func processTimePeriodSlider(_ sender: Any) {
        self.drawTimePeriod(value: self.timePeriodSldr.value)
    }
    
    @IBAction func processBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    @objc func orientationChanged(notification: Notification) {
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            print("[\(#function)] landscape")
            processUIOfLandscape()
        case .portrait, .portraitUpsideDown:
            print("[\(#function)] Portrait")
            processUIOfPortrait()
        default:
            print("[\(#function)] other")
        }
    }
    
    func processUIOfLandscape() {
        print("[\(#function)]")
    }
    
    func processUIOfPortrait() {
        print("[\(#function)]")
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
     * Name           : drawComponentsUI
     * Description    : Draw components for UI
     * Arguments      : Void
     * Returns        : Void
     ********************************************************************/
    func drawComponentsUI() {
        self.backBtn?.setTitleColor(CommonComponents.sharedInstance?.titleColor, for: .normal)
        self.backBtn?.backgroundColor = UIColor.white
        self.backBtn?.layer.cornerRadius = 5
        self.backBtn?.layer.borderWidth = 1
        self.backBtn?.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    /********************************************************************
     * Name           : showFadeIn
     * Description    : escaping closure function for drawing by fade-in
     * Arguments      : Void
     * Returns        : Void
     ********************************************************************/
    func showFadeIn() {
        UIView.animate(withDuration: showTime, animations: {() -> Void in
            self.flickrIV.alpha = 1.0
            self.index = self.index + 1
        }, completion: {(_ finished: Bool) -> Void in
            print("\(#function) Draw Image Completed")
        })
    }

    /********************************************************************
     * Name           : hideFadeOut
     * Description    : escaping closure function for hiding by fade-out
     * Arguments      : Void
     * Returns        : Void
     ********************************************************************/
    func hideFadeOut() {
        UIView.animate(withDuration: hideTime, animations: {() -> Void in
            print("\(#function) FadeOut Index :  \(self.index)")
            DispatchQueue.main.async {
                self.flickrIV.alpha = 0.0
            }
        }, completion: { _ in
            print("\(#function) Hide Image Completed")
        })
    }

    /********************************************************************
     * Name           : showActivityIndicator
     * Description    : show indicator with container
     * Arguments      : uiView -> UIView for drwing loading acivity indicator
     * Returns        : Void
     ********************************************************************/
    func showActivityIndicator(uiView: UIView) {
        DispatchQueue.main.async {
            self.loadingContainer.frame = uiView.frame
            self.loadingContainer.center = uiView.center
            self.loadingContainer.backgroundColor = UIColor.colorWithRGBHex(hex: 0xffffff, alpha: 0.3)
            
            let loadingView: UIView = UIView()
            loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
            loadingView.center = uiView.center
            loadingView.backgroundColor = UIColor.colorWithRGBHex(hex: 0x444444, alpha: 0.7)
            loadingView.clipsToBounds = true
            loadingView.layer.cornerRadius = 10
            
            self.actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
            self.actInd.center = CGPoint(x: loadingView.frame.size.width / 2,
                                         y: loadingView.frame.size.height / 2)
            self.actInd.hidesWhenStopped = true
            self.actInd.style = UIActivityIndicatorView.Style.whiteLarge
            loadingView.addSubview(self.actInd)
            self.loadingContainer.addSubview(loadingView)
            uiView.addSubview(self.loadingContainer)
                        
            self.actInd.startAnimating()
        }
    }
    
    /********************************************************************
     * Name           : dissmissActivityIndicator
     * Description    : hide Activity Indicator
     * Arguments      : actInd -> UIActivityIndicatorView for stoping animating
     * Returns        : Void
     ********************************************************************/
    func dissmissActivityIndicator(actInd: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            actInd.stopAnimating()
            self.loadingContainer.removeFromSuperview()
        }
    }
    
    /********************************************************************
     * Name           : drawFlickrImages
     * Description    : draw flickr images by periodic time
     * Arguments      : showFunc -> escaping closure for drawing image
                        hideFunc -> escaping closure for hiding image
     * Returns        : Void
     ********************************************************************/
    func drawFlickrImages(showFunc: @escaping () -> Void, hideFunc: @escaping () -> Void) {
        var timerInvalidate: Bool = false
        self.showActivityIndicator(uiView: self.view)
        
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            //CommonComponents.sharedInstance?.displayActivityIndicatorAlert()

            while !timerInvalidate {
                DispatchQueue.global(qos: .background).async(execute: {() -> Void in
                    //print("\(#function) Background global thread")

                    if self.index >= self.count {
                        self.index = 0
                        self.canGetImage = true
                        self.refreshFlickrImage()
                    }
                    
                    DispatchQueue.main.async {
                        
                        if self.isDrawImage == true {
                            if self.count > self.index {
                                self.flickrIV.sd_setImage(with: URL(string: self.flickrImgArr[self.index])!, completed: { (image, error, cacheType, imageURL) in
                                    
                                    showFunc()
                                })
                            }
                        } else {
                            print("\(#function) Showing Images is not ready...")
                        }
                        
                        print("\(#function) Global sleep \(self.timePeriodSldr.value) seconds")
                    }
                })
                
                Thread.sleep(forTimeInterval: TimeInterval(CommonComponents.timeSlideValue + Float(self.showTime + self.hideTime) ) )
                
                hideFunc()
                
                self.dissmissActivityIndicator(actInd: self.actInd)
                
                //print("\(#function) stopDrawImg : \(self.stopDrawImg)")
                if self.stopDrawImg == true {
                    timerInvalidate = true
                }
            }
        })
    }
    
    /********************************************************************
     * Name           : refreshFlickrImage
     * Description    : refresh flikr images array
     * Arguments      : Void
     * Returns        : Void
     ********************************************************************/
    func refreshFlickrImage() {
        if canGetImage == true {
            Alamofire.request(serverURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON {
                response in switch response.result {
                    
                case .success(let JSON):
                    if let response = JSON as? NSDictionary {
                        if let flickrDataArray = response.object(forKey: "items") as? NSArray {
                            
                            if self.count == self.flickrImgArr.count {
                                self.flickrImgArr.removeAll()
                            }
                            
                            self.count = flickrDataArray.count
                            print("\(#function) flickrDataArray Count: \(flickrDataArray.count)")
                            
                            for element in flickrDataArray {
                                
                                if let json = element as? NSDictionary {
                                    
                                    if let mediaImageArray = json.object(forKey: "media") as? NSDictionary {
                                        
                                        let mediaDataURL = mediaImageArray.object(forKey: "m") as? String
                                        if mediaDataURL != nil {
                                            
                                            self.flickrImgArr.append(mediaDataURL!)
                                            print(mediaDataURL!)
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    self.index = 0
                    self.count = self.flickrImgArr.count
                    self.canGetImage = false
                    self.isDrawImage = true
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

