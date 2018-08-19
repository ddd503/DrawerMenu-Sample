//
//  RootViewController.swift
//  DrawerMenu-Sample
//
//  Created by kawaharadai on 2018/08/15.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {
    
    private var jobOfferViewController = JobOfferViewController()
    private var navigationViewController: UINavigationController!
    private var drawerViewController = LeftNavigationDrawerViewController()
    private var lightGrayView = UIView()
    private var isOpenMenu = false
    private let drawOpenPercentage: CGFloat = 0.7
    private let openMenuSpeed: TimeInterval = 0.15
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    // MARK: - Private
    private func setup() {
        self.setControllers()
    }
    
    private func setControllers() {
        
        guard let jobOfferViewController = UIStoryboard(name: "JobOfferViewController", bundle: nil)
            .instantiateInitialViewController() as? JobOfferViewController else {
                fatalError("JobOfferViewController is nil")
        }
        
        guard let leftNavigationDrawerViewController = UIStoryboard(name: "LeftNavigationDrawerViewController", bundle: nil)
            .instantiateInitialViewController() as? LeftNavigationDrawerViewController else {
                fatalError("LeftNavigationDrawerViewController is nil")
        }
        
        // rootControllerにJobOfferViewControllerを追加(navigationViewController付きで)
        self.jobOfferViewController = jobOfferViewController
        self.navigationViewController = UINavigationController(rootViewController: self.jobOfferViewController)
        self.addChildViewController(self.navigationViewController)
        self.navigationViewController.view.frame = CGRect(x: 0,
                                                          y: 0,
                                                          width: UIScreen.main.bounds.width,
                                                          height: UIScreen.main.bounds.height)
        // グレーのViewを生成してjobOfferViewControllerに被さるように配置
        self.lightGrayView = self.makeLightGrayView()
        self.navigationViewController.view.addSubview(self.lightGrayView)
        // タップアクションとパンアクションを追加
        self.setGesture(view: self.navigationViewController.view)
        
        self.view.addSubview(self.navigationViewController.view)
        
        self.setNabigationBarItem(controller: self.jobOfferViewController)
        
        // navigationViewControllerのrootにRootViewControllerを指定
        self.navigationViewController.didMove(toParentViewController: self)
        
        // ドロワーメニュー (leftDrawerMenuViewController) を追加
        self.drawerViewController = leftNavigationDrawerViewController
        self.drawerViewController.delegate = self
        self.addChildViewController(self.drawerViewController)
        self.view.addSubview(self.drawerViewController.view)
        
        // drawerViewControllerのrootにRootViewControllerを指定
        self.drawerViewController.didMove(toParentViewController: self)
        
        // ドロワーメニューの上にNavigationViewControllerが配置されるように設定。
        self.view.bringSubview(toFront: self.navigationViewController.view)
    }
    
    private func setNabigationBarItem(controller: UIViewController) {
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "hamburger_menu"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(self.menu(sender:)))
        controller.navigationItem.leftBarButtonItem = leftBarButton
        controller.title = "求人一覧"
    }
    
    private func setGesture(view: UIView) {
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.menu(sender:)))
        view.addGestureRecognizer(tapAction)
        let panAction = UIPanGestureRecognizer(target: self, action: #selector(self.panAction(sender:)))
        view.addGestureRecognizer(panAction)
    }
    
    private func menuAnimation(isOpen: Bool, animationView: UIView) {
        if isOpen {
            // メニューを閉じる
            self.isOpenMenu = false
            self.lightGrayView.isHidden = true
            UIView.animate(withDuration: openMenuSpeed, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.lightGrayView.alpha = 0
                animationView.frame.origin.x = 0
            }, completion: { _ in
                self.jobOfferViewController.navigationItem.leftBarButtonItem?.isEnabled = true
            })
        } else {
            // メニューを出す
            self.isOpenMenu = true
            self.lightGrayView.isHidden = false
            UIView.animate(withDuration: openMenuSpeed, delay: 0.0, options: .curveLinear, animations: {
                self.lightGrayView.alpha = 0.5
                animationView.frame.origin.x = self.drawerViewController.view.frame.width * self.drawOpenPercentage
            }, completion: { _ in
                self.jobOfferViewController.navigationItem.leftBarButtonItem?.isEnabled = true
            })
        }
    }
    
    private func makeLightGrayView() -> UIView {
        let lightGrayView = UIView(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: self.navigationViewController.view.frame.size.width,
                                                 height: self.navigationViewController.view.frame.size.height))
        lightGrayView.backgroundColor = .lightGray
        lightGrayView.alpha = 0.0
        lightGrayView.isHidden = true
        lightGrayView.isUserInteractionEnabled = true
        return lightGrayView
    }
    
    // MARK: - Action
    @objc func menu(sender: Any?) {
        // 非オープン時の場合のタップ対応
        if self.lightGrayView.isHidden {
            guard sender as? UITapGestureRecognizer == nil else { return }
        }
        guard let navigationController = self.jobOfferViewController.navigationController else { return }
        self.jobOfferViewController.navigationItem.leftBarButtonItem?.isEnabled = false
        self.menuAnimation(isOpen: self.isOpenMenu, animationView: navigationController.view)
    }
    
    @objc func panAction(sender: UIPanGestureRecognizer) {
        
        guard let target = sender.view else { return }
        
        switch sender.state {
        case .changed:
            guard target.frame.origin.x >= 0 else { return }
            
            let point = sender.translation(in: self.view)
            // トップ画面での左スワイプ防止
            if self.lightGrayView.isHidden {
                guard point.x >= 0 else { return }
            }
            
            self.lightGrayView.isHidden = false
            
            // 画面横移動
            let moved = CGPoint(x: target.frame.origin.x + point.x, y: target.frame.origin.y)
            target.frame.origin = moved
            
            // 徐々にグレーかける
            if self.lightGrayView.alpha >= 0 || self.lightGrayView.alpha <= 0.5 {
                self.lightGrayView.alpha = target.frame.origin.x * 0.002
            }
            sender.setTranslation(.zero, in: self.view)
        case .ended:
            // どれだけスワイプしたらアニメーション入れるか
            if self.isOpenMenu {
                self.menuAnimation(isOpen: target.frame.size.width * 0.8 > target.frame.origin.x, animationView: target)
            } else {
                self.menuAnimation(isOpen: target.frame.size.width * 0.3 > target.frame.origin.x, animationView: target)
            }
            sender.setTranslation(.zero, in: self.view)
        default:
            break
        }
    }
}

// MARK: - DrawerViewControllerDelegate
extension RootViewController: DrawerViewControllerDelegate {
    func reloadJobOfferList(sort: SortType) {
        self.jobOfferViewController.reload(sortType: sort)
        self.menu(sender: nil)
    }
}
