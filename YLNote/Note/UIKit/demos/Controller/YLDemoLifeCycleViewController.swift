//
//  YLLifeCycleViewController.swift
//  YLNote
//
//  Created by tangh on 2021/1/25.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLDemoLifeCycleViewController: UIViewController {

    deinit {
        print("\(self)：\(#function)");
    }
    convenience init(name: String) {
        print("\(#function)");
        self.init(nibName:nil, bundle:nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("\(#function)");
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        print("\(self)：\(#function)");
    }
    
    override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        print("\(self)：\(#function)");
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "生命周期+布局扩展区域"
        print("\(self)：\(#function)");
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self)：\(#function)");
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self)：\(#function)");
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("\(self)：\(#function)");
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("\(self)：\(#function)");
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(self)：\(#function)");
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(self)：\(#function)");
    }
    
    //MARK: function
    func setupUI() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        testLayout(type: 4)
    }
    
    /// 使原点从navigationbar下面开始(不四周扩展)的几种方式
    /**在iOS7以后 UIViewController 开始使用全屏布局，而且是默认的属性。通常涉及到布局，就离不开这个属性 edgesForExtendedLayout，它是一个类型为UIExtendedEdge的属性，指定UIViewController上的根视图self.view边缘要延伸的方向。由于iOS7鼓励全屏布局，所以它的默认值是UIRectEdgeAll，四周边缘均延伸，就是说，如果即使视图中上有UINavigationBar，下有UITabBar，那么视图仍会延伸覆盖到四周的区域。
     */
    func testLayout(type: Int) {
       addTestView(type: type)
        switch type {
        case 1:
            self.edgesForExtendedLayout = [] // 设置是否四周可扩展，默认是all
        case 2:
            self.navigationController?.navigationBar.isTranslucent = false // 设置导航栏不透明 true:半透明 false：不透明，iOS7之后默认为true
        case 3:
            self.extendedLayoutIncludesOpaqueBars = false // 不透明的条下是否可以扩展,必须搭配导航条不透明使用
            self.navigationController?.navigationBar.isTranslucent = false // 设置导航栏不透明(ios7默认是true)
        case 4:
            // 只针对scrollview的滚动区域有效
            if #available(iOS 11.0, *) {
                self.textView.contentInsetAdjustmentBehavior = .automatic
            } else {
                // Fallback on earlier versions
                self.automaticallyAdjustsScrollViewInsets = false
            }
        default:
            self.edgesForExtendedLayout = .all
        }
    }
    
    func addTestView(type: Int) {
        if type == 4 {
            self.textView.frame = CGRect(x: 0, y: 0, width: YLScreenSize.width, height: YLScreenSize.height)
            view.addSubview(self.textView)
        } else {
            self.aView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            self.view.addSubview(self.aView)
        }
        
    }
    
    //MARK: lazy
    lazy var aView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    lazy var textView: UITextView = {
        let v = UITextView()
        v.isEditable = false
        v.backgroundColor = .red
        v.text = "着一身素纱轻衣，化身一古风女子。或是，舞袖长空，起舞娉婷；或是，诗书两行，浅墨入画；又或，弹指弄弦，低吟浅唱。情系古风，方可感受一种唯美古风韵，悠悠华夏情。喜欢中国风古风的诗情画意，唯美意境！感谢献声中国风古风的歌手们，感谢古风里有河图着一身青衫，戴一银冠，化身一古风男子。或是，墨染袖间，执笔画惊鸿；或是，血染黄沙，挥剑刺苍穹；又或，卸甲归田，灵隐深山处。着一身素纱轻衣，化身一古风女子。或是，舞袖长空，起舞娉婷；或是，诗书两行，浅墨入画；又或，弹指弄弦，低吟浅唱。情系古风，方可感受一种唯美古风韵，悠悠华夏情。喜欢中国风古风的诗情画意，唯美意境！感谢献声中国风古风的歌手们，感谢古风里有河图着一身青衫，戴一银冠，化身一古风男子。或是，墨染袖间，执笔画惊鸿；或是，血染黄沙，挥剑刺苍穹；又或，卸甲归田，灵隐深山处。着一身素纱轻衣，化身一古风女子。或是，舞袖长空，起舞娉婷；或是，诗书两行，浅墨入画；又或，弹指弄弦，低吟浅唱。情系古风，方可感受一种唯美古风韵，悠悠华夏情。喜欢中国风古风的诗情画意，唯美意境！感谢献声中国风古风的歌手们，感谢古风里有河图着一身青衫，戴一银冠，化身一古风男子。或是，墨染袖间，执笔画惊鸿；或是，血染黄沙，挥剑刺苍穹；又或，卸甲归田，灵隐深山处。着一身素纱轻衣，化身一古风女子。或是，舞袖长空，起舞娉婷；或是，诗书两行，浅墨入画；又或，弹指弄弦，低吟浅唱。情系古风，方可感受一种唯美古风韵，悠悠华夏情。喜欢中国风古风的诗情画意，唯美意境！感谢献声中国风古风的歌手们，感谢古风里有河图着一身青衫，戴一银冠，化身一古风男子。或是，墨染袖间，执笔画惊鸿；或是，血染黄沙，挥剑刺苍穹；又或，卸甲归田，灵隐深山处。着一身素纱轻衣，化身一古风女子。或是，舞袖长空，起舞娉婷；或是，诗书两行，浅墨入画；又或，弹指弄弦，低吟浅唱。情系古风，方可感受一种唯美古风韵，悠悠华夏情。喜欢中国风古风的诗情画意，唯美意境！感谢献声中国风古风的歌手们，感谢古风里有河图着一身青衫，戴一银冠，化身一古风男子。或是，墨染袖间，执笔画惊鸿；或是，血染黄沙，挥剑刺苍穹；又或，卸甲归田，灵隐深山处。着一身素纱轻衣，化身一古风女子。或是，舞袖长空，起舞娉婷；或是，诗书两行，浅墨入画；又或，弹指弄弦，低吟浅唱。情系古风，方可感受一种唯美古风韵，悠悠华夏情。喜欢中国风古风的诗情画意，唯美意境！感谢献声中国风古风的歌手们，感谢古风里有河图或是，舞袖长空，起舞娉婷；或是，诗书两行，浅墨入画；又或，弹指弄弦，低吟浅唱。情系古风，方可感受一种唯美古风韵，悠悠华夏情。喜欢中国风古风的诗情画意，唯美意境！感谢献声中国风古风的歌手们，感谢古风里有河图着一身青衫，戴一银冠，化身一古风男子。或是，墨染袖间，执笔画惊鸿；或是，血染黄沙，挥剑刺苍穹；又或，卸甲归田，灵隐深山处。着一身素纱轻衣，化身一古风女子。或是，舞袖长空，起舞娉婷；或是，诗书两行，浅墨入画；又或，弹指弄弦，低吟浅唱。情系古风，方可感受一种唯美古风韵，悠悠华夏情。喜欢中国风古风的诗情画意，唯美意境！感谢献声中国风古风的歌手们，感谢古风里有河图"

        return v
    }()
}
