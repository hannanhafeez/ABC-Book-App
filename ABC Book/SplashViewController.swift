//
//  SplashViewController.swift
//  ABC Book
//
//  Created by Dr. Atta on 29/06/2018.
//  Copyright © 2018 Dr. Atta. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		moveMain()
		
		
		/*Timer.init(fire: NSDate.init() as Date, interval: 4, repeats: false) { (_) in
			UIStoryboardSegue.init(identifier: "ShowMain", source: self, destination: UIViewController.init())
		}*/
    }
	
//	function to wait with splash
	func moveMain(){
		Timer.scheduledTimer(withTimeInterval: 2.5 , repeats: false) { (_) in
			//UIStoryboardSegue.init(identifier: "ShowMain", source: self, destination: UIViewController.init())
			self.performSegue(withIdentifier: "ShowMain", sender: self)
		}
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
