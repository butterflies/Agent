//
//  NetworkManager.swift
//  Agent
//
//  Created by 于劲 on 2017/11/16.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

enum NetworkManager{
    //------------------
    //用户中心
    case login(String, String) //用户账户密码登录接口
    case loginByMobile(username:String, password:String, areaCode:String) //用户手机号登录接口
    case sms(phoneNo:String, areaCode:String, msgType:Int) //获取手机短信验证码
    case refresh //刷新token接口
    //------------------
    //基础&核心服务
    case gameInfo(serverCode:String)
    case banner //查询banner
    case agreement //查询协议
    case affirm(agreementId:Int) //确认协议
    case noticeScroll //查询首页公告区域公告
    case noticeList(page:Int, pageSize:Int) //查询公告列表
    case noticeDetail(noticeId:Int) //查询公告详情
    case myagent(agentType:Int, page:Int, pageSize:Int) //查询我的代理列表
    case myagentInfo(subAgentId:Int) //查询我的代理详情
    case updateRemark(subAgentId:Int, remark:String) //修改我的代理备注
    case myagentNew(name:String, userId:Int, tel:String, roleId:Int, verificationCode:String, vipAgentOpenLimit:Int, normalAgentOpenLimit:Int, subAgentOpenLimit:Int, validityPeriod:String) //开通代理
    case agentSwitch(agentId:Int, enable:String) //启用，禁用代理
    case pwdChange(pwd:String, rpwd:String) //修改密码
    case myInfo //13查询当前代理信息
    case editHI(headerImgSrc:String) //14修改头像
    case editNick(nickName:String) //15修改昵称
    case typeInfo //查询特权信息
    case bindTel(tel:String, verificationCode:String) //17绑定安全手机
    case updateBind(oldVerificationCode:String, tel:String, newVerificationCode:String) //18修改安全手机
    case bindSMS(tel:String, smsType:Int) //22获取绑定安全手机验证码
    case verificationCode(smsType:Int) //23修改安全手机验证码
    case agentSMS(tel:String, smsType:Int) //24开通代理手机验证码
    case upload(file:Data)//25头像上传
    //编辑安全手机
    case inviteGet //邀请玩家
    case inviteList(page:Int, pageSize:Int) //查询邀请玩家列表
    //------------------
    //购卡服务
    case goodList //查询房卡列表接口
    case goodDetail(time:String, page:Int) //查询购卡明细
    case goodDetailCollect(time:String) //查询购卡张数／次数接口
    case check //点击房卡校验接口
    case buycardGood(payTypeInchannel:Int, channel:Int, paySource:Int, goodId:Int, activityId:Int) //支付接口
    case unpaidToPay(orderNo:String) //待支付订单支付接口
    //------------------
    //售卡服务
    case sellcardToPlayer(playerID:Int, number:Int) //1给玩家售卡接口
    case sellcardToAgent(agentID:Int, number:Int) //2给下级代理售卡接口
    case statisticAllNum(time:String) //3查询售卡张数
    case statisticList(time:String, sortType:Int, pageIndex:Int, pageNum:Int) //4查询售卡明细
    case customerAllNum(searchId:Int, startDate:Int, endDate:Int) //5售卡人数/人次统计
    case customerRecently(searchId:Int, startDate:Int, endDate:Int, sortType:Int, pageIndex:Int, pageNum:Int) //6最近售卡/某玩家明细
    case customerTotallist(searchId:Int, startDate:Int, endDate:Int, sortType:Int, pageIndex:Int, pageNum:Int) //7售卡次数/张数
    case recentlyPlayer(searchId:Int, startDate:Int, endDate:Int, sortType:Int, pageIndex:Int, pageNum:Int) //8最近售卡的玩家
    case recentlyAgent(searchId:Int, startDate:Int, endDate:Int, sortType:Int, pageIndex:Int, pageNum:Int) //9最近售卡的代理
    case playerSearch(searchId:Int) //10查询玩家信息
    case agentSearch(searchId:Int) //11查询代理信息
    case agentCheck(searchId:Int) //12查询代理信息
    //------------------
    //支付中心
    case cancel(orderNo:String) //取消待支付订单接口
    case orderlist(year:String, month:String, page:String, type:String) //订单查询接口
}

class TokenSource{
    var token:String?
    init(){}
}

protocol AuthorizedTargetType: TargetType {
    var needsAuth: Bool { get }
}

struct AuthPlugin: PluginType {
    let tokenClosure: () -> String?
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard
            let token = tokenClosure(),
            let target = target as? AuthorizedTargetType,
            target.needsAuth
            else {
                return request
        }
        
        var request = request
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        return request
    }
}

extension NetworkManager: AuthorizedTargetType{
    var baseURL:URL{
//        switch self {
//        case .upload(_, let fileName):
//            return URL(string: "https://gatewaytest.xianlaigame.com?file="+fileName)!
//        default:
            return URL(string: "https://gatewaytest.xianlaigame.com")!
//        return URL(string: "http://172.16.70.128:6010")!
//        }
    }

    var path:String{
        switch self{
        //------------------
        //用户中心
        case .login(_,_):
            return "/api/auth/login"
        case .loginByMobile(_, _, _):
            return "/api/auth/loginByMobile"
        case .sms(_, _, _):
            return "/api/auth/sms"
        case .refresh:
            return "/api/auth/refresh"
            
        //------------------
        //基础&核心服务
        case .gameInfo(_):
            return "/api/agent/gameInfo"
        case .banner:
            return "/api/agent/core/banner/list"
        case.agreement:
            return "/api/agent/core/agreement/get"
        case .affirm(_):
            return "/api/agent/core/agreement/affirm"
        case .noticeScroll:
            return "/api/agent/core/notice/scroll"
        case .noticeList(_, _):
            return "/api/agent/core/notice/list"
        case .noticeDetail(_):
            return "/api/agent/core/notice/detail"
        case .myagent(_, _, _):
            return "/api/agent/core/myagent/list"
        case .myagentNew(_, _, _, _, _, _, _, _, _):
            return "/api/agent/core/myagent/new"
        case .pwdChange(_, _):
            return "/api/agent/core/pwd/change"
        case .myInfo:
            return "/api/agent/core/my/info"
        case .editNick(_):
            return "/api/agent/core/my/edit/nick"
        case .bindTel(_, _):
            return "/api/agent/core/tel/bind"
        case .bindSMS(_, _):
            return "/api/agent/core/verificationCode/bindtel"
        case .updateBind(_, _, _):
            return "/api/agent/core/tel/bind/update"
        case .verificationCode(_):
            return "/api/agent/core/verificationCode"
        case .agentSMS(_, _):
            return "/api/agent/core/verificationCode/register"
        case .upload(_):
            return "/api/agent/core/common/upload"
            
        //------------------
        //购卡服务
        case .goodList:
            return "/api/agent/buycard/goodList"
        case .goodDetail(_, _):
            return "/api/agent/buycard/goodDetail"
        case .goodDetailCollect(_):
            return "/api/agent/buycard/goodDetailCollect"
        case .check:
            return "/api/agent/buycard/good/check"
        case .buycardGood(_,_,_,_,_):
            return "/api/agent/buycard/good"
        case .unpaidToPay(_):
            return "/api/agent/buycard/unpaidToPay"
            
        //------------------
        //售卡服务
        case .sellcardToPlayer(_, _):
            return "/api/agent/sellcard/sellcardToPlayer"
        case .sellcardToAgent(_, _):
            return "/api/agent/sellcard/sellcardToAgent"
        case .statisticAllNum(_):
            return "/api/agent/sellcard/statistic/allNum"
        case .statisticList(_, _, _, _):
            return "/api/agent/sellcard/statistic/list"
        case .customerAllNum(_, _, _):
            return "/api/agent/sellcard/customer/allNum"
        case .customerRecently(_, _, _, _, _, _):
            return "/api/agent/sellcard/customer/recently"
        case .customerTotallist(_, _, _, _, _, _):
            return "/api/agent/sellcard/customer/totallist"
        case .recentlyPlayer(_,_,_,_,_,_):
            return "/api/agent/sellcard/recently/player"
        case .recentlyAgent(_,_,_,_,_,_):
            return "/api/agent/sellcard/recently/agent"
        case .playerSearch(_):
            return "/api/agent/sellcard/player/search"
        case .agentSearch(_):
            return "/api/agent/sellcard/agent/search"
        //------------------
        //支付中心
        case.cancel(_):
            return "/api/agent/pay/processing/cancel"
        case .orderlist:
            return "/api/agent/pay/processing/orderlist"
        default:
            return ""
        }
    }
    
    var method:Moya.Method{
        switch self {
        case .refresh:
            return .get
        default:
            return .post
        }
    }
    
    public var task:Task{
        switch self {
        //用户中心
        case .login(let usr, let pwd):
            var params:[String:Any] = [:]
            params["username"] = usr
            params["password"] = pwd
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .loginByMobile(let username, let password, let areaCode):
            var params:[String:Any] = [:]
            params["username"] = username
            params["password"] = password
            params["areaCode"] = areaCode
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .sms(let phoneNo, let areaCode, let msgType):
            var params:[String:Any] = [:]
            params["phoneNo"] = phoneNo
            params["areaCode"] = areaCode
            params["msgType"] = msgType
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
            
        case .cancel(let orderNo):
            var params:[String:Any] = [:]
            params["orderNo"] = orderNo
            return .requestParameters(parameters: params, encoding: DataEncoding.default)
        case .orderlist(let year, let month, let page, let type):
            var params:[String:Any] = [:]
            params["year"] = year
            params["month"] = month
            params["page"] = page
            params["type"] = type
            return .requestParameters(parameters: params, encoding: DataEncoding.default)
        case .buycardGood(let payTypeInchannel, let channel, let paySource, let goodId, let activityId):
            var data:[String:Any] = [:]
            
            data["payTypeInchannel"] = payTypeInchannel
            data["channel"] = channel
            data["paySource"] = paySource
            data["goodId"] = goodId
            data["activityId"] = activityId
            
            return .requestParameters(parameters: data, encoding: DataEncoding.default)

        // 购卡服务
        case .goodDetail(let time, let page):
            var data:[String:Any] = [:]
            
            data["time"] = time
            data["page"] = page
            
            return .requestParameters(parameters: data, encoding: DataEncoding.default)
            
        case .goodDetailCollect(let time):
            var data:[String:Any] = [:]
            
            data["time"] = time
            return .requestParameters(parameters: data, encoding: DataEncoding.default)
            
        // 售卡服务
        case .sellcardToPlayer(let playerID, let number):
            var data:[String:Any] = [:]
            
            data["playerID"] = playerID
            data["number"] = number
            
            return .requestParameters(parameters: data, encoding: DataEncoding.default)
            
        case .sellcardToAgent(let agentID, let number):
            var data:[String:Any] = [:]
            
            data["agentID"] = agentID
            data["number"] = number
            
            return .requestParameters(parameters: data, encoding: DataEncoding.default)

        case .statisticAllNum(let time):
            var data:[String:Any] = [:]
            
            data["time"] = time
            
            return .requestParameters(parameters: data, encoding: DataEncoding.default)

        case .customerAllNum(let searchId, let startDate, let endDate):
            var data:[String:Any] = [:]
            if searchId != 0{
                data["searchId"] = searchId
            }
            if startDate != 0 {
                data["startDate"] = startDate
            }
            if endDate != 0 {
                data["endDate"] = endDate
            }
            
            return .requestParameters(parameters: data, encoding: DataEncoding.default)
            
        case .statisticList(let time, let sortType, let pageIndex, let pageNum):
            var data:[String:Any] = [:]
            
            data["time"] = time
            if sortType != 0 {
                data["sortType"] = sortType
            }
            if pageIndex != 0 {
                data["pageIndex"] = pageIndex
            }
            if pageNum != 0{
                data["pageNum"] = pageNum
            }
            
            return .requestParameters(parameters: data, encoding: DataEncoding.default)
        case .customerRecently(let searchId, let startDate, let endDate, let sortType, let pageIndex, let pageNum),
             .customerTotallist(let searchId, let startDate, let endDate, let sortType, let pageIndex, let pageNum),
             .recentlyPlayer(let searchId, let startDate, let endDate, let sortType, let pageIndex, let pageNum),
             .recentlyAgent(let searchId, let startDate, let endDate, let sortType, let pageIndex, let pageNum):
            
            var data:[String:Any] = [:]
            if searchId != 0{
                data["searchId"] = searchId
            }
            if startDate != 0 {
                data["startDate"] = startDate
            }
            if endDate != 0 {
                data["endDate"] = endDate
            }
            if searchId != 0{
                data["sortType"] = sortType
            }
            if startDate != 0 {
                data["pageIndex"] = pageIndex
            }
            if endDate != 0 {
                data["pageNum"] = pageNum
            }

            return .requestParameters(parameters: data, encoding: DataEncoding.default)
        case .playerSearch(let searchId),
                 .agentSearch(let searchId):
            var data:[String:Any] = [:]
            data["searchId"] = searchId
            return .requestParameters(parameters: data, encoding: DataEncoding.default)
            
        // 支付
        case .orderlist(let year, let month, let page, let type):
            var data:[String:Any] = [:]
            
            data["year"] = year
            data["month"] = month
            data["page"] = page
            data["type"] = type
            
            return .requestParameters(parameters: data, encoding: DataEncoding.default)
        case .cancel(let orderNo),
             .unpaidToPay(let orderNo):
            var data:[String:Any] = [:]
            
            data["orderNo"] = orderNo
            
            return .requestParameters(parameters: data, encoding: DataEncoding.default)
            
        case .refresh:
            return .requestPlain
            
        // 服务
        case .noticeList(let page, let pageSize):
            var data:[String:Any] = [:]
            if page != 0{
                data["page"] = page
            }
            if pageSize != 0 {
                data["pageSize"] = pageSize
            }
            return .requestParameters(parameters: data, encoding: DataEncoding.default)
        case .noticeDetail(let noticeId):
            var data:[String:Any] = [:]
                data["noticeId"] = noticeId
            return .requestParameters(parameters: data, encoding: DataEncoding.default)
        case .myagent(let agentType, let page, let pageSize):
            var data:[String:Any] = [:]
            if agentType != 0{
                data["agentType"] = agentType
            }
            if page != 0 {
                data["page"] = page
            }
            if pageSize != 0 {
                data["pageSize"] = pageSize
            }
            return .requestParameters(parameters: data, encoding: DataEncoding.default)
            
        case .myagentNew(let name, let userId, let tel, let roleId, let verificationCode, let vipAgentOpenLimit, let normalAgentOpenLimit, let subAgentOpenLimit, let validityPeriod):
            var data:[String:Any] = [:]
            data["name"] = name
            data["userId"] = userId
            data["tel"] = tel
            data["roleId"] = roleId
            data["verificationCode"] = verificationCode

            if vipAgentOpenLimit != 0{
                data["vipAgentOpenLimit"] = vipAgentOpenLimit
            }
            if normalAgentOpenLimit != 0 {
                data["normalAgentOpenLimit"] = normalAgentOpenLimit
            }
            if subAgentOpenLimit != 0 {
                data["subAgentOpenLimit"] = subAgentOpenLimit
            }
            data["validityPeriod"] = validityPeriod
            return .requestParameters(parameters: data, encoding: DataEncoding.default)
            
        case .editNick(let nickName):
            var data:[String:Any] = [:]
            data["nickName"] = nickName
            return .requestParameters(parameters: data, encoding: DataEncoding.default)
            
        case .bindSMS(let tel, let smsType):
            var data:[String:Any] = [:]
            data["tel"] = tel
            data["smsType"] = smsType
            return .requestParameters(parameters: data, encoding: DataEncoding.default)
            
        case .bindTel(let tel, let verificationCode):
            var data:[String:Any] = [:]
            data["tel"] = tel
            data["verificationCode"] = verificationCode
            return .requestParameters(parameters: data, encoding: DataEncoding.default)

        case .updateBind(let oldVerificationCode, let tel, let newVerificationCode):
            var data:[String:Any] = [:]
            data["oldVerificationCode"] = oldVerificationCode
            data["tel"] = tel
            data["newVerificationCode"] = newVerificationCode
            return .requestParameters(parameters: data, encoding: DataEncoding.default)
            
        case .verificationCode(let smsType):
            var data:[String:Any] = [:]
            data["smsType"] = smsType
            return .requestParameters(parameters: data, encoding: DataEncoding.default)
            
        case .agentSMS(let tel, let smsType):
            var data:[String:Any] = [:]
            data["tel"] = tel
            data["smsType"] = smsType
            return .requestParameters(parameters: data, encoding: DataEncoding.default)
            
        case .pwdChange(let pwd, let rpwd):
            var data:[String:Any] = [:]
            data["pwd"] = pwd
            data["rpwd"] = rpwd
            return .requestParameters(parameters: data, encoding: DataEncoding.default)
            
        case .upload(let file):
            var data:[String:Any] = [:]
            data["file"] = file
//            let param = ["file":"file"]
//            let fileData = try! Data(contentsOf: file)
//            let formData2 = MultipartFormData(provider: .data(fileData), name: "file", fileName: "headImg.png", mimeType: "image/png")
//            return .uploadCompositeMultipart([formData2], urlParameters: param)
            return .requestParameters(parameters: data, encoding: ImageEncoding.default)
            
        default:
            let params:[String:Any] = [:]
            return .requestParameters(parameters: params, encoding: DataEncoding.default)
        }
    }
    
    public var validate:Bool{
        return false
    }
    
    public var sampleData: Data{
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var headers:[String:String]?{
//        switch self{
//        case .login, .refresh:
            return ["Content-Type" : "application/json"]
//        default:
//            return ["Content-Type" : "application/octet-stream"]
//        }
    }
    
    public var needsAuth: Bool {
        switch self {
        case .login:
            return false
        default:
            return true
        }
    }
}

//func handleError(statusCode: Int) -> () {
//    //服务器报错等问题
//    print("请求错误！错误码：\(statusCode)")
//}
//
//func handleFailure(error: MoyaError) -> () {
//    //没有网络等问题
//    print("请求失败！错误信息：\(error.errorDescription ?? "")")
//}
//
//struct Network {
//    
//    static func request(_ target:NetworkManager,
//                        success successCallback: @escaping(JSON) -> Void,
////                        error errorCallback: @escaping(Int) -> Void,
////                        failure failureCallback: @escaping(MoyaError) -> Void,
//                        provider:MoyaProvider<NetworkManager>){
//        provider.request(target) { result in
//            switch result {
//            case let .success(response):
//                do {
//                    //如果数据返回成功则直接将结果转为JSON
//                    try response.filterSuccessfulStatusCodes()
//                    let json = try JSON(response.mapJSON())
//                    successCallback(json)
//                }
//                catch let error {
//                    //如果数据获取失败，则返回错误状态码
//                    handleError(statusCode: (error as! MoyaError).response!.statusCode)
//                }
//            case let .failure(error):
//                //如果连接异常，则返沪错误信息（必要时还可以将尝试重新发起请求）
//                handleFailure(error: error)
//            }
//        }
//    }
//}
