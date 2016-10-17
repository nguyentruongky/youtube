# Youtube iOS clone
This is the sample followed the tutorial at 
[Let's build that app](https://www.youtube.com/playlist?list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj). Highly recommend for experiened iOS developers. 

###What will you get 
- Build an application completely. 
- Create the UI programmatically. 
- Start the app programmatically in AppDelegate. 
- Update later...

###Timeline
The project started at 4AM, Oct 13, 2016. 

[Ep1](https://youtu.be/3Xv1mJvwXok): Built the home screen with collection view.
		
	// start the app with Storyboard 
	// add this in AppDelegate, function application:didFinishLaunchingWithOptions
	
	window = UIWindow(frame: UIScreen.main.bounds)
	window?.makeKeyAndVisible()
	window?.rootViewController = UINavigationController(rootViewController: HomeViewController(collectionViewLayout: UICollectionViewFlowLayout()))
-
	// Extend the UIView to easier add constraint 
	func addConstraints(withFormat format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
[Ep2](https://youtu.be/APQVltARKF8) and [Ep3](https://youtu.be/rRhJGnSmEKQ): Add dummy data and format cell size. Custom the navigation bar and status bar. Create a custom menu bar with UICollectionView. Change to image tint color.

	// change the navigation bar color in AppDelegate
	UINavigationBar.appearance().barTintColor = UIColor.rgb(red: 230, green: 32, blue: 31)
-
	// Change the status bar text color and background color 
	application.statusBarStyle = .lightContent
    let statusBarBackground = UIView()
    statusBarBackground.backgroundColor = UIColor.rgb(red: 194, green: 31, blue: 31)
    window?.addSubview(statusBarBackground)
    window?.addConstraints(withFormat: "H:|[v0]|", views: statusBarBackground)
    window?.addConstraints(withFormat: "V:|[v0(20)]", views: statusBarBackground)
-
	// change the image color 
	cell.imageView.image = UIImage(named: imageName[indexPath.row])?.withRenderingMode(.alwaysTemplate)
	cell.imageView.tintColor = UIColor.rgb(red: 91, green: 14, blue: 13)

[Ep4](https://youtu.be/Zud56x_VYvs): Add dummy data, estimate the title size to change the title label height dynamically. Create 2 bar buttons and change their color. 

	// estimate the text size 
	let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
	let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
	let estimatedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
	if estimatedRect.size.height > 20 {
		// do something 
	}
	else {
		// do other things
	}
                                
[Ep5](https://youtu.be/WjrvcGAZfoI): Working with the JSON. Call the service, get the result and parse JSON to the model. Extend the UIImageView to download image with GCD. 

	// load image in async in extension UIImageView 
    URLSession.shared.dataTask(with: URLRequest(url: URL(string: urlString)!), completionHandler: { (data, response, error) in
	            
	    if error != nil {
	        print(error)
	        return
	    }
	    
	    DispatchQueue.main.sync {
	        
	        let imageToCache = UIImage(data: data!)
	        
	        if self.imageUrl == urlString {
	            self.image = imageToCache
	        }
	        
	        imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
	        self.image = imageToCache
	    }
	}).resume()
		
[Ep6](https://www.youtube.com/watch?v=XFvs6eraBXM): Shows a solution to solve loading wrong image in UITableView/UICollectionView scrolling. Use cache and check the url before use the cache is a good idea. 

	// create cache  
	let imageCache = NSCache<AnyObject, AnyObject>()
-
	// Check the image loaded in cache 
	imageUrl = urlString
	image = nil
	    
	if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
	    image = imageFromCache
	    return
	}
-
	// save image to cache 
	let imageToCache = UIImage(data: data!)
	imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)


[Ep7](https://youtu.be/2kwCfFG5fDA): show how to create a custom menu with the collection by adding directly to UIWindow. An easy animation with UIView. Separate the code setting launcher with home view controller.

	// get the current window 
	if let window = UIApplication.shared.keyWindow {
		// do something 
		window.addSubview(your_view)
	}
	
[Ep8](https://youtu.be/PNmuTTd5zWc): create collection view to create menu. Create menu item with image view and label. Override the hightlighted property to show the tap effect. 

	// hightlight effect when tap on the menu 
	override var isHighlighted: Bool {
	    didSet {
	        backgroundColor = isHighlighted  ? UIColor.darkGray : UIColor.white
	        nameLabel.textColor = isHighlighted  ? UIColor.white : UIColor.black
	        iconImageView.tintColor = isHighlighted  ? UIColor.white : UIColor.darkGray
	    }
	}

[Ep9](https://youtu.be/DYsfAD01fYk): Talk about lazy var. Use lazy var to initialize SettingLauncher and pass delegate. 

A small thing I don't agree with Brian is: I use a delegate instead of his passing HomeViewController instance. 

A small difference in my code: I handle selected action right with delay action. 

	// Lazy instantiate
	  lazy var settingLauncher : SettingLauncher = {
        let launcher = SettingLauncher()
        launcher.delegate = self
        return launcher
    }()
-
	// Handle menu selected 
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
	    let setting = settings[indexPath.row]
	    handleDismiss()
	    perform(#selector(handleSettingSelected), with: setting, afterDelay: dismissAnimationDuration)
	}
	    
	func handleSettingSelected(setting: Setting) {
	    guard setting.name != "Cancel" else { return }
	    delegate?.didSelectSettingMenu(setting: setting)
	}

[Ep10](https://www.youtube.com/watch?v=naMqoh1_5To&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=10): Create setting enumeration to easier handle setting selection. 

[Ep11](https://www.youtube.com/watch?v=XgRbj4YeG9I&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=11): Animate to hide the navigation bar. An awesome trick here: create constraint for the menu bar to the top layout, add an red view to hide the space under the bar. 

	// hide navigation bar and add red view 
	navigationController?.hidesBarsOnSwipe = true
	let redView = UIView()
	redView.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31)
	view.addSubview(redView)
	view.addConstraints(withFormat: "H:|[v0]|", views: redView)
	view.addConstraints(withFormat: "V:[v0(50)]", views: redView)
	
-

	// add constraint for the menu bar to the top layout 
	menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true

A new way to add constraint

	// add constraint for indicator view (horizontalBarView)
	barViewLeftAnchor = horizontalBarView.leftAnchor.constraint(equalTo: leftAnchor)
	barViewLeftAnchor!.isActive = true
	horizontalBarView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
	horizontalBarView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/4).isActive = true
	horizontalBarView.heightAnchor.constraint(equalToConstant: 3).isActive = true
	
Animate the indicator view: change the constraint constant and update layout

- Update later...

