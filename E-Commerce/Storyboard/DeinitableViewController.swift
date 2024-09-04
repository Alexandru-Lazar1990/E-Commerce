//
//  DeinitableViewController.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 04.09.2024.
//

import UIKit
import Combine

class DeinitableViewController: UIViewController, Storyboarded {
    let dismiss = PassthroughSubject<Void, Never>()

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismiss.send()
    }
}
