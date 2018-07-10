//
//  LeftSegue.swift
//  ABC Book
//
//  Created by Dr. Atta on 21/06/2018.
//  Copyright © 2018 Dr. Atta. All rights reserved.
//

import UIKit
class LeftSegue: UIStoryboardSegue{

	override func perform() {
		MoveBack()
	}
	
	
	func MoveBack(){
		let sourceVC = self.source
		let destinationVC = self.destination
		
		destinationVC.view.transform = CGAffineTransform.init(scaleX: 0.05, y: 0.05)
		let rect = UIScreen.main.bounds
		let vert = rect.height/2
		let hort = rect.width/2
		destinationVC.view.center = CGPoint.init(x: hort, y: vert)
		
		UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
			destinationVC.view.transform = CGAffineTransform.identity
		}, completion: {
			success in sourceVC.present(destinationVC, animated: true, completion: nil)
		})
		
		
	}
}
