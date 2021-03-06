//
//  MyAgentAdmin.swift
//  Agent
//
//  Created by 于劲 on 2017/12/8.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON
import XLPagerTabStrip
class AgentViewPageController: ButtonBarPagerTabStripViewController {
    var isReload = false
    override func viewDidLoad() {
        settings.style.buttonBarItemFont = .systemFont(ofSize: 14)
        settings.style.buttonBarItemTitleColor = UIColor.darkGray
        settings.style.buttonBarHeight = 35
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarHeight = 2
        settings.style.selectedBarBackgroundColor = .orange
        super.viewDidLoad()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let page1 = MyAgentList(style: .plain, pageInfo: "全部代理")
        let page2 = MyAgentList(style: .plain, pageInfo: "VIP代理")
        let page3 = MyAgentList(style: .plain, pageInfo: "普通代理")
        
        guard isReload else {
            return [page1, page2, page3]
        }
        
        let childViews = [page1, page2, page3]
        return childViews
    }
    
    override func reloadPagerTabStripView() {
        super.reloadPagerTabStripView()
    }
}

class MyAgentAdmin: UIViewController {

    @IBOutlet weak var btnOpen: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imgNoData: UIImageView!
    @IBOutlet weak var lblNoData: UILabel!

    @IBOutlet weak var segSort: UISegmentedControl!
    
    var sourceData = [MyAgentCellModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        segSort.selectedSegmentIndex = 0
        segSort.addTarget(self, action: #selector(self.segDidchange(_:)), for: .valueChanged)
        
        btnOpen.addTarget(self, action: #selector(toOpen(_:)), for: .touchUpInside)
        request(.myagent(agentType: segSort.selectedSegmentIndex, page: 1, pageSize: 0), success: handleData)
//                let customerPageController = PagingMenuController(options: options)
//                customerPageController.view.frame.origin.y += 200
//                addChildViewController(customerPageController)
//                view.addSubview(customerPageController.view)
        
        let agentViewPage = AgentViewPageController()
        agentViewPage.view.frame.origin.y += 150
        addChildViewController(agentViewPage)
        view.addSubview(agentViewPage.view)
        
        autoFit()
    }

    override func viewDidAppear(_ animated: Bool) {
        let count = sourceData.count
        showNodata(dataCount: count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func toOpen(_ button:UIButton){
        let payVC = loadVCfromMain(identifier: "myAgentToOpen") as! MyAgentToOpen
        present(payVC, animated: true, completion: nil)
    }

    func handleData(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
            //            sourceData.removeAll()
            print(result)
            let data = result["data"]
            let dataArr = data["myAgentList"].array
            for(_, data) in (dataArr?.enumerated())!{
                //data["id"].intValue,data["createTime"].stringValue,data["title"].stringValue
//                sourceData.append([NoticeListCellModel(id: data["id"].intValue, title: data["title"].stringValue, createTime: data["createTime"].stringValue)])
            }
            tableView.reloadData()
            let count = sourceData.count
            showNodata(dataCount: count)
        }
    }
    
    func segDidchange(_ segmented:UISegmentedControl){
        print(segmented.selectedSegmentIndex)
        request(.myagent(agentType: segSort.selectedSegmentIndex, page: 1, pageSize: 0), success: handleData)
    }

    func showNodata(dataCount:Int){
        if dataCount > 0 {
            imgNoData.isHidden = true
            lblNoData.isHidden = true
            btnOpen.isHidden = true
            tableView.isHidden = false
        }else{
            imgNoData.isHidden = false
            lblNoData.isHidden = false
            btnOpen.isHidden = false
            tableView.isHidden = true
        }
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
