//
//  UIViewController+Alert.swift
//  Agent
//
//  Created by 于劲 on 2017/12/7.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import Toast_Swift

extension UIViewController{
    func alertResult(code:Int) -> Void {
        let alertController = UIAlertController(title: "系统提示",message: errMsg.desc(key: code), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
            action in
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func toastMSG(result:JSON) -> Void {
        let msg = result["message"].stringValue
        self.view.makeToast(msg, duration: 2, position: .center)
    }

    func request(_ target:NetworkManager,
                                       success successCallback: @escaping(JSON) -> Void
        //error errorCallback: @escaping(Int) -> Void,
        //failure failureCallback: @escaping(MoyaError) -> Void
        ){
        let source = TokenSource()
        source.token = getSavedToken()
        let provider = MoyaProvider<NetworkManager>(plugins:[AuthPlugin(tokenClosure: {return source.token})])

        func handleError(statusCode: Int) -> () {
            //服务器报错等问题
            print("请求错误！错误码：\(statusCode)")
            
            let alertController = UIAlertController(title: "网络错误",message: "请求错误！错误码：\(statusCode)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好的", style: .default, handler: {
                action in
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)

        }
        
        func handleFailure(error: MoyaError) -> () {
            //没有网络等问题
            print("请求失败！错误信息：\(error.errorDescription ?? "")")
            let alertController = UIAlertController(title: "网络错误",message: "请求失败！错误信息：\(error.errorDescription ?? "")", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好的", style: .default, handler: {
                action in
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }

        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    //如果数据返回成功则直接将结果转为JSON
                    try response.filterSuccessfulStatusCodes()
                    let json = try JSON(response.mapJSON())
                    successCallback(json)
                }
                catch let error {
                    //如果数据获取失败，则返回错误状态码
                    handleError(statusCode: (error as! MoyaError).response!.statusCode)
                }
            case let .failure(error):
                //如果连接异常，则返沪错误信息（必要时还可以将尝试重新发起请求）
                //服务器报错等问题
                handleFailure(error: error)
            }
        }
    }
    
    func autoFit(){
        let radio:CGFloat = UIScreen.main.bounds.width / 375.0
        //let radioH:Float =
        let subviews = self.view.subviews
        
        
        for(_, view) in subviews.enumerated(){
            if view.subviews.count > 0 {
                let subviews = view.subviews
                for(_, view) in subviews.enumerated(){
                    fitRadio(v: view, radio: radio)
                }
//                view.frame.size.width *= radio
//                view.frame.size.height *= radio
            }
            fitRadio(v: view, radio: radio)
        }
    }
    
    private func fitRadio(v:UIView, radio:CGFloat){
        if v.isKind(of: UINavigationBar.self) {
            return
        }
        v.autoresizesSubviews = true
        v.frame.origin.x *= radio
        v.frame.origin.y *= radio
        v.frame.size.width *= radio
        v.frame.size.height *= radio
    }

    func underLine(v:UIView){
        let line = UIView(frame: CGRect(x: -UIScreen.main.bounds.width/2, y: v.frame.origin.y + v.frame.height, width: UIScreen.main.bounds.width*0.9, height: 1))
        view.addSubview(line)
    }
    
    func addNavigationBar() -> UINavigationBar{
        var navigationBar:UINavigationBar?
        
        let width = UIScreen.main.bounds.width
        navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: width, height: 44))
        
        let navigationItem = UINavigationItem()
        let leftButton = UIBarButtonItem(image: UIImage(named: "ico_back"), style: .plain, target: self, action: #selector(onBack(_:)))
        navigationItem.setLeftBarButton(leftButton, animated: true)
        navigationBar?.pushItem(navigationItem, animated: true)
        
        view.addSubview(navigationBar!)
        
        return navigationBar!
    }
    
    func onBack(_ sender:UIBarButtonItem){
        dismiss(animated: true, completion: nil)
    }
//    func setAgent(data:JSON)->(){
//        var agent:[String:Any] = [:]
//
//        agent["account"] = data["account"].stringValue
//        agent["agentId"] = data["agentId"].intValue
//        agent["roleId"] = data["roleId"].intValue
//        agent["name"] = data["name"].stringValue
//        agent["nickName"] = data["nickName"].stringValue
//        agent["gameName"] = data["gameName"].stringValue
//        agent["serverCode"] = data["serverCode"].stringValue
//        agent["headImg"] = data["headImg"].stringValue
//        agent["lastBuyTime"] = data["lastBuyTime"].stringValue
//        
//        UserDefaults.standard.set(agent, forKey: "AGENT")
//    }
}
