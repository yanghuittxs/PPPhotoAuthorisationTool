//
//  ViewController.swift
//  PPPhotoAuthorisationTool
//
//  Created by yanghuittxs on 07/12/2021.
//  Copyright (c) 2021 yanghuittxs. All rights reserved.
//

import UIKit
import PPPhotoAuthorisationTool

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        RRDeviceAuthorizationTools.deviceAuthorization(true, .photo) { type, status in
            if status == .authorized {
                print("~~~~获得相册权限")
            }
            else {
                print("~~~~")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

