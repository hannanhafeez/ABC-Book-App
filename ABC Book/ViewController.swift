//
//  ViewController.swift
//  ABC Book
//
//  Created by Dr. Atta on 22/06/2018.
//  Copyright © 2018 Dr. Atta. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds

// Class extesntion for using colors in hex code format
extension UIColor {
	
	convenience init(hexString: String) {
		let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
		var int = UInt32()
		Scanner(string: hex).scanHexInt32(&int)
		let a, r, g, b: UInt32
		switch hex.count {
		case 3: // RGB (12-bit)
			(a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
		case 6: // RGB (24-bit)
			(a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
		case 8: // ARGB (32-bit)
			(a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
		default:
			(a, r, g, b) = (255, 0, 0, 0)
		}
		self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
	}
}



class ViewController: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate {

	var myAudioPlayer = AVAudioPlayer()
	
	@IBOutlet weak var BannerView: GADBannerView!
	var interstitial: GADInterstitial!
	@IBOutlet weak var bigAlpha: UILabel!
	@IBOutlet weak var forLbl: UILabel!
	@IBOutlet weak var imgView: UIImageView!
	@IBOutlet weak var alphaDescription: UILabel!
	
	@IBOutlet weak var TapLbl: UILabel!
	
	var alphabet:[String] = [String]()
	var alphaDescript:[String] = [String]()
	var txtColorStr:[String] = [String]()
	var bgColor:[String] = [String]()
	
	var imgs:[UIImage]? = [UIImage]()
//	var textColors:[UIColor]? = [UIColor]()
	var TapImg:UIImageView = UIImageView()
	var TapImg2:UIImageView = UIImageView()
	var imgPosition = 0

	var idleTimeValue = 7
	var idleTimer:Timer?
	var font:UIFont?
	
	
	var tapCount:Int = 0
	//var anim:CAAnimation?
	
	// Banner Test ID: ca-app-pub-3940256099942544/2934735716
	// AdMob Original Banner ID: ca-app-pub-8799872830430840/7757527139
	let AdMobBannerID = "ca-app-pub-8799872830430840/7757527139"
	
	// Interstitial Test ID: ca-app-pub-3940256099942544/4411468910
	// AdMob Original Interstitial id: ca-app-pub-8799872830430840/6170324744
	let AdMobInterstitialID = "ca-app-pub-8799872830430840/6170324744"

	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		swipeInit()
		idleTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(self.idleTimeValue), repeats: false, block: { (true) in
			self.playAnim()
		})
		
//		var alphabet:[String] = ["A","B","C","D","E","F","G","H","I","J"]
		alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
		
		alphaDescript = ["Apple","Ball","Cat","Dog","Elephant","Fan","Goat","Horse","Ice Cream","Jug","Kite","Lamp","Mouse","Nurse","Owl","Pencil","Queen","Rainbow","Sun","Tree","Umbrella","Voilin","Watch","X-Ray","Yatch","Zebra"]
		
		txtColorStr = ["#FF1415","#46443e","#323025","#1B1B1B","#363636","#76B3E1","#6B4F34","#6B4F34","#805F42","#99B4CB","#8B5C27","#902E27","#827E86","#323450","#353535","#9BA65E","#2B0A08","#8070EA","#EECF60","#679129","#B96458","#544648","#6A986E","#8ED1C4","#354F7B","#424445"]
		
		bgColor = ["#f4d1c5","#f5e6b2","#f9efba","#e1aaaa","#e9bebe","#E7E7E7","#f0dbc7","#f7dfc8","#d0d0d0","#00192d","#f7dec1","#ffb3ae","#f7f0ff","#bfc4ff","#d2d2d2","#323429","#ffa19d","#29253e","#8e8b84","#ffffff","#ffffff","#ffc5ce","#befec4","#555555","#ededed","#d8d8d8"]
		
		
		for ind in 0...(alphabet.count - 1){
			
			let alp = "\(alphabet[ind])" + ".png"
			
			if UIImage(named: alp) != nil{
				imgs?.append(UIImage(named: alp)!)
			}
		}
		
		
		self.font = self.alphaDescription.font
		
		self.view.backgroundColor = UIColor(hexString: self.bgColor[0])
		self.bigAlpha.textColor = UIColor(hexString: self.txtColorStr[0])
		self.forLbl.textColor = UIColor(hexString: self.txtColorStr[0])
		self.alphaDescription.textColor = UIColor(hexString: self.txtColorStr[0])
		
		
		self.bigAlpha.text = self.alphabet[0]
		self.alphaDescription.text = self.alphaDescript[0]
		
		BannerView.adSize = kGADAdSizeSmartBannerPortrait
		BannerView.delegate = self
		BannerView.adUnitID = self.AdMobBannerID
		BannerView.rootViewController = self
		BannerView.load(GADRequest())
		
		interstitial = createAndLoadInterstitial()
		
}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	
	// MARK: - Application Functions
	
	func createAndLoadInterstitial() -> GADInterstitial {
		let inter = GADInterstitial(adUnitID: AdMobInterstitialID)
		inter.delegate = self
		inter.load(GADRequest())
		return inter
	}
	
	func callOnTap(){
		self.tapCount += 1
		if tapCount > 7{
			showInterstitial()
		}
		else{
			print("Tap Count: ", tapCount)
		}
		//tapCount = 0
	}
	
	
	func showInterstitial() {
		if interstitial.isReady {
			interstitial.present(fromRootViewController: self)
			interstitial = createAndLoadInterstitial()
			tapCount = 0
		}
		else{
			print("Ad is not ready!")
		}
	}
	

	
	
	func swipeInit(){
		TapImg.image = UIImage(named: "tap")
		TapImg.frame = CGRect.init(x: view.bounds.width * 0.6, y: (view.bounds.height * 0.85) - (view.bounds.width/6) , width: view.bounds.width/6	, height: view.bounds.width/6)
		TapImg.contentMode = UIViewContentMode.scaleAspectFit
		//TapLbl.alpha = 0
		TapImg.alpha = 0
		//TapImg.transform = CGAffineTransform.init(rotationAngle: 120)
		view.addSubview(TapImg)
		
		TapImg2.image = UIImage(named: "tap-reflected")
		TapImg2.frame = CGRect.init(x: (view.bounds.width * 0.4) - (view.bounds.width/6), y: (view.bounds.height * 0.85) - (view.bounds.width/6), width: view.bounds.width/6, height: view.bounds.width/6)
		TapImg2.contentMode = UIViewContentMode.scaleAspectFit
		TapImg2.alpha = 0
		view.addSubview(TapImg2)
		
		//TapLbl.bounds.origin.x = (view.bounds.width * 0.5) + (TapLbl.bounds.size.width * 0.5)
		
		//TapLbl.frame.origin.y = (TapImg.frame.origin.y) - (TapLbl.bounds.size.height * 0.5) - 25

	}
	
	
	
	@IBAction func swipeNext(_ sender: UISwipeGestureRecognizer) {

		//		if imgPosition < (imgs.count - 1) {
//				self.imgPosition += 1
//		}
		self.imgPosition += 1
		
		//TapLbl.textColor = UIColor.init(hexString: self.txtColorStr[self.imgPosition])
		
		//This condition will change when we have more than 26 images in image array
		if self.imgPosition >= (imgs?.count)!{
			imgPosition %= (imgs?.count)!
			
		}else if self.imgPosition >= (alphabet.count){
			imgPosition %= (alphabet.count)
		}
		
		UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
			self.bigAlpha.alpha = 0.1
			self.forLbl.alpha = 0.1
			self.imgView.alpha = 0
			self.alphaDescription.font = UIFont.init(name: "Marker Felt", size: 45)
		}) { (true) in
			
			//Change colors for each page
			self.changeColors(Position: self.imgPosition)

			
			self.bigAlpha.alpha = 1
			self.forLbl.alpha = 1
			self.imgView.alpha = 1
			self.alphaDescription.font = self.font
			
			self.bigAlpha.text = self.alphabet[self.imgPosition]
			self.imgView.image = self.imgs?[self.imgPosition]
			self.alphaDescription.text = self.alphaDescript[self.imgPosition]
			self.playSound(Position: self.imgPosition)
		}
		
		resetSuggestion()
		callOnTap()
	}
	
	
	@IBAction func swipeBack(_ sender: UISwipeGestureRecognizer) {
		self.imgPosition -= 1
		if self.imgPosition < 0{
			imgPosition = (imgs?.count)! - 1
		}
		
		//TapLbl.textColor = UIColor.init(hexString: self.txtColorStr[self.imgPosition])

		
		UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
			self.bigAlpha.alpha = 0
			self.imgView.alpha = 0
			self.alphaDescription.font = UIFont.init(name: "Marker Felt", size: 45)
		}) { (true) in
			
			//Change colors for each page
			self.changeColors(Position: self.imgPosition)
			
			self.bigAlpha.alpha = 1
			self.imgView.alpha = 1
			self.alphaDescription.font = self.font
			
			self.bigAlpha.text = self.alphabet[self.imgPosition]
			self.imgView.image = self.imgs?[self.imgPosition]
			self.alphaDescription.text = self.alphaDescript[self.imgPosition]
			self.playSound(Position: self.imgPosition)
		}
		resetSuggestion()
		callOnTap()
}
	
	
	@IBAction func tapPressed(_ sender: UITapGestureRecognizer) {
		playSound(Position: self.imgPosition)
		resetSuggestion()
		callOnTap()
	}
	
	func resetIdleTimer() {
		if let idleTimer = idleTimer {
			idleTimer.invalidate()
		}
		
		idleTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(idleTimeValue), repeats: false, block: { (true) in
			self.playAnim()
		})
	}
	
	func resetSuggestion(){
		//TapLbl.layer.removeAllAnimations()
		TapImg.layer.removeAllAnimations()
		TapImg2.layer.removeAllAnimations()
		self.TapImg.frame.origin.x = (view.bounds.width * 0.6)
		self.TapImg.frame.origin.y = self.view.bounds.height * 0.85 - self.view.bounds.width/6

		self.TapImg2.frame.origin.x =  (view.bounds.width * 0.4) - (view.bounds.width/6)
		self.TapImg2.frame.origin.y = self.view.bounds.height * 0.85 - self.view.bounds.width/6
		
		//			swipeInit()
		
		//TapLbl.alpha  = 0
		TapImg.alpha = 0
		TapImg2.alpha = 0
		
		self.resetIdleTimer()
	}
	
	func playSound(Position ind:Int){
		do{
			myAudioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: self.alphabet[ind], ofType: "mp3")!))
		}
		catch{
			print(error)
		}
		myAudioPlayer.prepareToPlay()
		myAudioPlayer.play()
	}
	
	
	
	func changeColors(Position ind:Int){
		self.view.backgroundColor = UIColor.init(hexString: self.bgColor[ind])
		
		self.bigAlpha.textColor = UIColor.init(hexString: self.txtColorStr[ind])
		self.forLbl.textColor = UIColor.init(hexString: self.txtColorStr[ind])
		self.alphaDescription.textColor = UIColor.init(hexString: self.txtColorStr[ind])

	}
	
	
	
	func playAnim() {
		TapImg.layer.allowsEdgeAntialiasing = true
		UIView.animateKeyframes(withDuration: 2, delay: 0, options: [.repeat , .calculationModeLinear], animations: {
			
			UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
				self.TapImg.alpha = 1
				//self.TapLbl.alpha = 1
			})
			
			UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2, animations: {
				self.TapImg.frame.origin.x += (self.view.bounds.width * 0.25) * 0.3
				self.TapImg.frame.origin.y -= (self.view.bounds.height / 14) * 0.6
			})
			
			
			
			UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2, animations: {
				self.TapImg.frame.origin.x += (self.view.bounds.width * 0.25) * 0.3
				self.TapImg.frame.origin.y -= (self.view.bounds.height / 14) * 0.3			})
			UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.2, animations: {
				self.TapImg.frame.origin.x += (self.view.bounds.width * 0.25 ) * 0.3
				self.TapImg.frame.origin.y -= (self.view.bounds.height / 14) * 0.1
			})
			
			
			UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: {
				self.TapImg.alpha = 0
				//self.TapLbl.alpha = 0
			})
			
			
			
		}, completion: { (finished) in
			self.TapImg.alpha = 0
			//self.TapLbl.alpha = 0
			self.TapImg.frame.origin.x = (self.view.bounds.width * 0.6)
			self.TapImg.frame.origin.y = self.view.bounds.height * 0.85 - self.view.bounds.width/6

		})
		
		
		UIView.animateKeyframes(withDuration: 2, delay: 1.2, options: [.repeat , .calculationModeLinear], animations: {
			
			UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
				self.TapImg2.alpha = 1
				//self.TapLbl.alpha = 1
			})
			
			UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2, animations: {
				self.TapImg2.frame.origin.x -= (self.view.bounds.width * 0.25) * 0.3
				self.TapImg2.frame.origin.y -= (self.view.bounds.height / 14) * 0.6
			})
			
			
			
			UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2, animations: {
				self.TapImg2.frame.origin.x -= (self.view.bounds.width * 0.25) * 0.3
				self.TapImg2.frame.origin.y -= (self.view.bounds.height / 14) * 0.3			})
			UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.2, animations: {
				self.TapImg2.frame.origin.x -= (self.view.bounds.width * 0.25 ) * 0.3
				self.TapImg2.frame.origin.y -= (self.view.bounds.height / 14) * 0.1
			})
			
			
			UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: {
				self.TapImg2.alpha = 0
				//self.TapLbl.alpha = 0
			})
			
			
			
		}, completion: { (finished) in
			self.TapImg2.alpha = 0
			//self.TapLbl.alpha = 0
			self.TapImg2.frame.origin.x =  (self.view.bounds.width * 0.4) - (self.view.bounds.width/6)
			self.TapImg2.frame.origin.y = self.view.bounds.height * 0.85 - self.view.bounds.width/6
			
		})
		
//		UIView.animate(withDuration: 2, delay: 0, options: [.repeat,.curveEaseInOut], animations: {
//
//		}, completion: nil)
	}

	
	// MARK: - GADBannerViewDelegate
	// Called when an ad request loaded an ad.
	func adViewDidReceiveAd(_ bannerView: GADBannerView) {
		print("Banner: ",#function)
	}
	
	// Called when an ad request failed.
	func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
		print("Banner: ","\(#function): \(error.localizedDescription)")
	}
	
	// Called just before presenting the user a full screen view, such as a browser, in response to
	// clicking on an ad.
	func adViewWillPresentScreen(_ bannerView: GADBannerView) {
		print("Banner: ",#function)
	}
	
	// Called just before dismissing a full screen view.
	func adViewWillDismissScreen(_ bannerView: GADBannerView) {
		print("Banner: ",#function)
	}
	
	// Called just after dismissing a full screen view.
	func adViewDidDismissScreen(_ bannerView: GADBannerView) {
		print("Banner: ",#function)
	}
	
	// Called just before the application will background or terminate because the user clicked on an
	// ad that will launch another application (such as the App Store).
	func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
		print("Banner: ",#function)
	}

	
//
	
//	func moveBack(){
//		
//		navigationController?.popViewController(animated: true)
//			
//		dismiss(animated: true, completion: nil)
//	
//	}
//	
//	@IBAction func BacktoC(_ sender: UISwipeGestureRecognizer) {
//		moveBack()
//	}
//	
//	@IBAction func BacktoB(_ sender: UISwipeGestureRecognizer) {
//		moveBack()
//	}
//	
//	@IBAction func BacktoA(_ sender: UISwipeGestureRecognizer) {
//		moveBack()
//	}
//	
//	@IBAction func BacktoD(_ sender: UISwipeGestureRecognizer) {
//		moveBack()
//	}
//	
//	@IBAction func BackRound(_ sender: UISwipeGestureRecognizer) {
//		//moveBack()
//	}
	
	// MARK: - GADInterstitialDelegate
	/// Tells the delegate an ad request succeeded.
	func interstitialDidReceiveAd(_ ad: GADInterstitial) {
		print("interstitialDidReceiveAd")
	}
	
	/// Tells the delegate an ad request failed.
	func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
		print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
	}
	
	/// Tells the delegate that an interstitial will be presented.
	func interstitialWillPresentScreen(_ ad: GADInterstitial) {
		print("interstitialWillPresentScreen")
	}
	
	/// Tells the delegate the interstitial is to be animated off the screen.
	func interstitialWillDismissScreen(_ ad: GADInterstitial) {
		print("interstitialWillDismissScreen")
	}
	
	/// Tells the delegate the interstitial had been animated off the screen.
	func interstitialDidDismissScreen(_ ad: GADInterstitial) {
		print("interstitialDidDismissScreen")
	}
	
	/// Tells the delegate that a user click will open another app
	/// (such as the App Store), backgrounding the current app.
	func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
		print("interstitialWillLeaveApplication")
	}
}
