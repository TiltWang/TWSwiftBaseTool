//
//  TWBannerView.swift
//  TWSwiftBaseTool_Example
//
//  Created by Tilt on 2019/10/17.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

enum TWScrollDirection {
    case unknown
    case up
    case down
    case left
    case right
}

class TWBannerView: UIView {
    
    
    var colorArr: Array<UIColor>? {
        didSet {
            if colorArr?.count ?? 0 > 0 {
                collectionView.contentSize = self.bounds.size
                
//                var postion: UICollectionViewScrollPosition
//                if let direction = self.configDirection, direction == ScrollDirection.up || direction == ScrollDirection.down
//                {
//                    postion = UICollectionViewScrollPosition.bottom
//                } else {
//                    postion = UICollectionViewScrollPosition.left
//                }
//
//                collectionView.scrollToItem(at: IndexPath.init(item: 0, section: 1), at: postion, animated: false)
                RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
            }
        }
    }
    
    var userIsDragging: Bool?
    
    var dragContentOffset: CGPoint?
    
    var currentDirection: TWScrollDirection?
    
    var configDirection: TWScrollDirection? {
        didSet {
            if let direction = configDirection, direction == TWScrollDirection.up || direction == TWScrollDirection.down {
                self.layout.scrollDirection = UICollectionViewScrollDirection.vertical
            } else {
                self.layout.scrollDirection = UICollectionViewScrollDirection.horizontal
            }
        }
    }
    
    
    lazy var pageControl = { () -> UIPageControl in
        let pageControl = UIPageControl.init()
        return pageControl
    }()
    
    lazy var layout = { () -> UICollectionViewFlowLayout in
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        return layout
    }()
    
    lazy var collectionView = { () -> UICollectionView in
        let collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: self.layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    lazy var timer: Timer = { () -> Timer in
        let timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        return timer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        destoryTimer()
    }
    
}


//MARK: timer function
extension TWBannerView {
    
    @objc func timerAction() {
        print("Timer is Action")
        if userIsDragging == true {
            return
        }
        
        guard let list = colorArr, list.count > 1 else {
            return
        }
        
        guard var visiblePath = collectionView.indexPathsForVisibleItems.last else {
            return;
        }
        
        var position: UICollectionViewScrollPosition
//        switch currentDirection {
//        case .right:
//            position = UICollectionViewScrollPosition.right
//        case .left:
//            position = UICollectionViewScrollPosition.left
//        case .up:
//            position = UICollectionViewScrollPosition.top
//        case .down:
//            position = UICollectionViewScrollPosition.bottom
//        default:
            switch configDirection {
            case .right:
                position = UICollectionViewScrollPosition.right
            case .left:
                position = UICollectionViewScrollPosition.left
            case .up:
                position = UICollectionViewScrollPosition.top
            case .down:
                position = UICollectionViewScrollPosition.bottom
            default:
            position = UICollectionViewScrollPosition.left
            }
//        }
        
        var scrollPath: IndexPath = IndexPath.init(item: 0, section: 0)
        if position == UICollectionViewScrollPosition.left || position == UICollectionViewScrollPosition.bottom {
            if visiblePath.item == list.count - 1 {
                scrollPath = IndexPath.init(item: 0, section: (visiblePath.section) + 1)
            } else {
                scrollPath = IndexPath.init(item: visiblePath.item + 1, section: visiblePath.section)
            }
            collectionView.scrollToItem(at: scrollPath, at: position, animated: true)
            
            if scrollPath.section == 2 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self.collectionView.scrollToItem(at: IndexPath.init(item: scrollPath.item, section: 0), at: position, animated: false)
                }
            }
            
        } else {
            if visiblePath.item == 0  && visiblePath.section == 0 {
                collectionView.scrollToItem(at: IndexPath.init(item: 0, section: 2), at: position, animated: false)
                visiblePath.section = 2
            }
            if visiblePath.item == 0 {
                scrollPath = IndexPath.init(item: list.count - 1, section: visiblePath.section - 1)
            } else {
                scrollPath = IndexPath.init(item: visiblePath.item - 1, section: visiblePath.section)
            }
            collectionView.scrollToItem(at: scrollPath, at: position, animated: true)
            
            if scrollPath.section == 0 {
                self.collectionView.scrollToItem(at: IndexPath.init(item: scrollPath.item, section: 2), at: position, animated: false)
            }
        }
                
    }
    
    func destoryTimer() {
        timer.invalidate()
    }
    
    func pauseTimer() {
        timer.fireDate = Date.distantFuture
    }
    
    func continueTimer() {
        timer.fireDate = Date.distantPast
    }
    
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension TWBannerView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ((self.colorArr?.count ?? 0) > 1) ?  3 : 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colorArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = self.colorArr?[indexPath.item]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.bounds.size
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        userIsDragging = true
        dragContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            let offset = scrollView.contentOffset
            if layout.scrollDirection == UICollectionViewScrollDirection.horizontal {
                if offset.x > dragContentOffset?.x ?? 0 {
                    currentDirection = TWScrollDirection.right
                } else {
                    currentDirection = TWScrollDirection.left
                }
            } else {
                if offset.y > dragContentOffset?.y ?? 0 {
                    currentDirection = TWScrollDirection.up
                } else {
                    currentDirection = TWScrollDirection.down
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.userIsDragging = false
            }
        } else {
            currentDirection = TWScrollDirection.unknown
        }
    }
    
}

