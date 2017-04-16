//
//  ViewUtils.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/16/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import UIKit

class ViewUtils {
    static func showToast(view : UIView) {
        
        UIView.transition(with: view,
                          duration: 0.6,
                          options: .transitionCrossDissolve,
                          animations: { view.isHidden = false },
                          completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIView.transition(with: view,
                              duration: 0.6,
                              options: .transitionCrossDissolve,
                              animations: { view.isHidden = true },
                              completion: nil)
        }
    }
}
