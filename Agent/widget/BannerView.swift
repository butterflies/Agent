//
//  BannerView.swift
//  Agent
//
//  Created by 于劲 on 2017/11/24.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

///** 滚动图宽度 */
//fileprivate var cycleScrollViewWidth : CGFloat? = nil
///** 滚动图高度 */
//fileprivate var cycleScrollViewHeight : CGFloat? = nil
/** 滚动的UIScrollView */
fileprivate var scroll : UIScrollView? = nil
/** 图片的url数组 */
fileprivate var imageURLArray = [AnyObject]()
/** 定时器 */
fileprivate var timer : Timer? = nil
/** 当前显示的图片在数组中的下标 */
fileprivate var cycleIndex : NSInteger = 0
/** 左边的图片在数组中的下标 */
fileprivate var leftCycleIndex : NSInteger = 0
/** 右边的图片在数组中的下标 */
fileprivate var rightCycleIndex : NSInteger = 0
/** 左边的图片 */
fileprivate var leftImageView : UIImageView? = nil
/** 中间的图片 */
fileprivate var centerImageView : UIImageView? = nil
/** 右边的图片 */
fileprivate var rightImageView : UIImageView? = nil
/** 间隔时间 */
fileprivate var timeInterval : CGFloat = 3.0
/** 白点 */
fileprivate var pageControl : UIPageControl? = nil

class BannerView: UIView, UIScrollViewDelegate {
    
    weak var delegate: BannerScrollViewDelegate?
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    convenience init(width: CGFloat, height: CGFloat) {
//        self.init()
//        cycleScrollViewWidth = width
//        cycleScrollViewHeight = height
//        self.backgroundColor = UIColor.white
//        
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    /**
     *  图片url数组
     */
    var imageURLs: Array<Any>? {
        set {
            imageURLArray = newValue! as [AnyObject]
            creatScroll()
        }
        get {
            return imageURLArray
        }
    }
    /**
     *  创建滚动视图
     */
    fileprivate func creatScroll () {
        /** 图片数组不为空 */
        if imageURLArray.count != 0 {
            scroll?.removeFromSuperview()
            self.addSubview(scroll!)
            scroll?.delegate = self
            scroll?.snp.makeConstraints({ (make) in
                make.left.equalTo(self).offset(0)
                make.right.equalTo(self).offset(0)
                make.top.equalTo(self).offset(0)
                make.bottom.equalTo(self).offset(0)
            })
            cycleIndex = 0
            /** 只有一张图片 */
            if imageURLArray.count == 1 {
                /** 创建只有一张图的轮播图 */
                creatOneImage()
            }
            else {
                /** 创建有多张图片的轮播图 */
                creatMoreImage()
            }
            pageControl?.removeFromSuperview()
            pageControl = UIPageControl()
            pageControl?.numberOfPages = imageURLArray.count
            pageControl?.currentPage = cycleIndex;
            pageControl?.hidesForSinglePage = true
            pageControl?.pageIndicatorTintColor = UIColor.white
            pageControl?.currentPageIndicatorTintColor = UIColor.red
            self.addSubview(pageControl!)
            pageControl?.snp.makeConstraints({ (make) in
                make.left.equalTo(self.snp.left).offset(0)
                make.right.equalTo(self.snp.right).offset(0)
                make.bottom.equalTo(self.snp.bottom).offset(0)
                make.height.equalTo(20)
            })
            creatTimer()
            creatTap()
        }
    }
    /**
     *  创建有多张图片的轮播图
     */
    fileprivate func creatMoreImage() {
        /** 设置滚动范围 */
        scroll?.contentSize = CGSize(width: self.frame.width * 3, height: 0)
        cycleIndex = 0
        leftCycleIndex = imageURLArray.count - 1
        rightCycleIndex = cycleIndex + 1
        
        leftImageView = UIImageView()
        leftImageView?.sd_setImage(with: URL(string: imageURLArray[leftCycleIndex] as! String))
        leftImageView?.contentMode = .scaleToFill
        scroll?.addSubview(leftImageView!)
        leftImageView?.backgroundColor = UIColor.magenta
        leftImageView?.snp.makeConstraints({ (make) in
            make.left.equalTo(scroll!.snp.left).offset(0)
            make.width.equalTo(self.frame.width)
            make.top.equalTo(scroll!.snp.top).offset(0)
            make.height.equalTo(self.frame.height)
        })
        
        centerImageView = UIImageView()
        centerImageView?.sd_setImage(with: URL(string: imageURLArray[cycleIndex] as! String))
        centerImageView?.contentMode = .scaleToFill
        scroll?.addSubview(centerImageView!)
        centerImageView?.backgroundColor = UIColor.magenta
        centerImageView?.snp.makeConstraints({ (make) in
            make.left.equalTo(leftImageView!.snp.right).offset(0)
            make.width.equalTo(self.frame.width)
            make.top.equalTo(scroll!.snp.top).offset(0)
            make.height.equalTo(self.frame.height)
        })
        rightImageView = UIImageView()
        rightImageView?.sd_setImage(with: URL(string: imageURLArray[rightCycleIndex] as! String))
        rightImageView?.contentMode = .scaleToFill
        scroll?.addSubview(rightImageView!)
        rightImageView?.backgroundColor = UIColor.magenta
        rightImageView?.snp.makeConstraints({ (make) in
            make.left.equalTo(centerImageView!.snp.right).offset(0)
            make.width.equalTo(self.frame.width)
            make.top.equalTo(scroll!.snp.top).offset(0)
            make.height.equalTo(self.frame.height)
        })
        
        /** 设置当前显示位置 */
        scroll?.setContentOffset(CGPoint(x: self.frame.width, y: 0), animated: false)
        
    }
    
    /**
     *  创建只有一张图的轮播图
     */
    fileprivate func creatOneImage() {
        scroll?.contentSize = CGSize(width: 0, height: 0)
        centerImageView = UIImageView()
        let url = URL(string: imageURLArray[0] as! String)
        centerImageView?.sd_setImage(with: url)
        centerImageView?.contentMode = .scaleToFill
        scroll?.addSubview(centerImageView!)
        centerImageView?.backgroundColor = UIColor.magenta
        centerImageView?.snp.makeConstraints({ (make) in
            make.left.equalTo(scroll!.snp.left).offset(0)
            make.width.equalTo(self.frame.width)
            make.top.equalTo(scroll!.snp.top).offset(0)
            make.height.equalTo(self.frame.height)
        })
    }
    
    /**
     *  点击图片事件
     */
    @objc fileprivate func clickScroll() -> Void {
        if imageURLArray.count != 0 {
            if delegate != nil {
                delegate!.didSelectCycleScrollView(index: cycleIndex)
            }
            
        }
    }
    /**
     *  创建手势点击
     */
    fileprivate func creatTap() {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(clickScroll))
        scroll?.addGestureRecognizer(tap)
    }
    
    /**
     *  创建定时器
     */
    fileprivate func creatTimer() -> Void {
        timer?.invalidate()
        timer = nil
        if (timer == nil && imageURLArray.count > 1) {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector: #selector(timeAction), userInfo: nil, repeats: true)
        }
    }
    /**
     *  定时器事件
     */
    @objc fileprivate func timeAction() -> Void {
        scroll?.setContentOffset(CGPoint(x:self.frame.width * 2, y:0), animated: true)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        cycleIndex = cycleIndex + 1
        leftCycleIndex = cycleIndex - 1
        rightCycleIndex = cycleIndex + 1
        
        if cycleIndex == imageURLArray.count - 1 {
            rightCycleIndex = 0
        }
        if cycleIndex == imageURLArray.count {
            cycleIndex = 0
            leftCycleIndex = imageURLArray.count - 1
            rightCycleIndex = cycleIndex + 1
        }
        
        //        print("left:\(leftCycleIndex) center:\(cycleIndex) right:\(rightCycleIndex)")
        
        leftImageView?.sd_setImage(with: URL(string: imageURLArray[leftCycleIndex] as! String))
        centerImageView?.sd_setImage(with: URL(string: imageURLArray[cycleIndex] as! String))
        rightImageView?.sd_setImage(with: URL(string: imageURLArray[rightCycleIndex] as! String))
        scroll?.setContentOffset(CGPoint(x:self.frame.width * 1, y:0), animated: false)
        pageControl?.currentPage = cycleIndex;
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        cycleScrollViewPause()
        
    }
    /**
     *  用户拖动图片后处理
     */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //        print(scroll!.contentOffset.x / self.frame.width)
        if scroll!.contentOffset.x / self.frame.width == 0.0 {
            cycleIndex = cycleIndex - 1
            leftCycleIndex = cycleIndex - 1
            rightCycleIndex = cycleIndex + 1
            
            
        } else if scroll!.contentOffset.x / self.frame.width == 1.0 {
            
        } else if scroll!.contentOffset.x / self.frame.width == 2.0 {
            cycleIndex = cycleIndex + 1
            leftCycleIndex = cycleIndex - 1
            rightCycleIndex = cycleIndex + 1
        } else {}
        
        if cycleIndex == imageURLArray.count - 1 {
            rightCycleIndex = 0
        }
        if cycleIndex == imageURLArray.count || cycleIndex == 0{
            cycleIndex = 0
            leftCycleIndex = imageURLArray.count - 1
            rightCycleIndex = cycleIndex + 1
        }
        if cycleIndex == -1 {
            cycleIndex = imageURLArray.count - 1
            leftCycleIndex = cycleIndex - 1
            rightCycleIndex = 0
        }
        
        leftImageView?.sd_setImage(with: URL(string: imageURLArray[leftCycleIndex] as! String))
        centerImageView?.sd_setImage(with: URL(string: imageURLArray[cycleIndex] as! String))
        rightImageView?.sd_setImage(with: URL(string: imageURLArray[rightCycleIndex] as! String))
        scroll?.setContentOffset(CGPoint(x:self.frame.width * 1, y:0), animated: false)
        pageControl?.currentPage = cycleIndex;
        cycleScrollViewStart()
    }
    
    /**
     *  定时器暂停
     */
    func cycleScrollViewPause() -> Void {
        if (timer != nil) {
            timer?.fireDate = Date.distantFuture
        }
    }
    /**
     *  定时器开始
     */
    func cycleScrollViewStart() -> Void {
        if (timer != nil) {
            timer?.fireDate = NSDate(timeIntervalSinceNow: TimeInterval(timeInterval)) as Date
        }
    }
    
    //MARK: - lazy
    /**
     *  scrollView
     */
    fileprivate lazy var scroll: UIScrollView? = {
        let scro = UIScrollView()
        scro.backgroundColor = UIColor.black
        scro.bounces = false
        scro.isPagingEnabled = true
        scro.layer.masksToBounds = true
        scro.alwaysBounceVertical = false
        scro.alwaysBounceHorizontal = true
        scro.showsVerticalScrollIndicator = false
        scro.showsHorizontalScrollIndicator = false
        return scro
    }()
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
/**
 *  点击视图后的代理
 */
protocol BannerScrollViewDelegate : NSObjectProtocol {
    func didSelectCycleScrollView(index: NSInteger)
}
