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

[Ep12](https://youtu.be/ZxIAT7f-yh8): Cool animation and binding menu item and content item. Change the video collection view Home view controller to a collection view with 4 item, horizontal flow layout and paging. One again, I use a delegation instead of passing a home view controller instance to menu bar. 

Bind the menu item ưith the content offset. The menu item width is equal to the content width / number of menu items

	menuBar.barViewLeftAnchor?.constant = scrollView.contentOffset.x / 4

Update the menu icon: 

	override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        
        menuBar.collectionView.selectItem(at: IndexPath(item: Int(index), section: 0), animated: true, scrollPosition: [])
    }

When the menu item selected, pass the menu index to the home view controller via delegation. 

	menuDelegate?.didSelectMenuAtIndexPath(indexPath: indexPath)

[Ep13](https://youtu.be/elvK3TYnzIw): Add a collection view inside a collection view to show the list of videos in every cell. Update the title when the content changed. 

[Ep14](https://youtu.be/77nQN0JzBH4): Add new services to get different videos content. Create 2 new cells inherit from FeedCell to get and fill data. I did a difference with Brian. In HomeViewController, cellForItemAtIndexPath, I use an array of ids, instead of if condition.

	// The last cellIs is must, because of collection view's prefetching mechanism. 
	// This id is use for the account cell. 
	let cellIds = [cellId, trendingCellId, subscriptionCellId, cellId]
	let identifier = cellIds[indexPath.item]
	let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)

[Ep15](https://www.youtube.com/watch?v=11aHute59QQ&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=15): Awesome trick here. Improve code in api service parse data. Move setting data from api service to model. Let model handle what belong to model. 

Prevent application crash with safe unwrap optional. Instead of using `if let` as the video, I use `guard`

	guard let data = data else { return }
	guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: AnyObject]] else { return }
	
New way to set data to properties. Set a dictionary instead of every property. A notice here: the raw data key name has to match with the property name, otherwise, app will crash. 

	channel!.setValuesForKeys(value as! [String: AnyObject])
	
instead of 

	channel?.name = values["name"] as! String
    channel?.profile_image_name = values["profile_image_name"] as! String

Brian also showed me how to prevent crash when the raw data has more properties than my model. He created a SafeJsonObjet 

	class SafeJsonObject : NSObject {
	    override func setValue(_ value: Any?, forKey key: String) {
	        
	        let selectorName = capitalFirstCharacter(of: key)
	        let selector = NSSelectorFromString("set\(selectorName):")
	        let response = self.responds(to: selector)
	        
	        guard response else { return }
	        
	        super.setValue(value, forKey: key)
	    }
	 	
	 	// this is an improvement for Brian's way.    
	    func capitalFirstCharacter(of string: String) -> String {
	        let first = String(string.characters.prefix(1)).capitalized
	        let other = String(string.characters.dropFirst())
	        return "\(first)\(other)"
	    }
	}

[Ep16](https://www.youtube.com/watch?v=NpG8iaM0Sfs&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=16): Show me how to play a video file with AVPlayer. The AVPlayer can play a file only, so that the link without direct to a file, nothing happen, example, youtube, film streaming link... 

	let urlString = "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
	if let url = URL(string: urlString) {
	    let player = AVPlayer(url: url)
	    
	    let playerLayer = AVPlayerLayer(player: player)
	    layer.addSublayer(playerLayer)
	    playerLayer.frame = frame
	    
	    player.play()
	}

Don't forget import AVFoundation module 

	import AVFoundation
	
[Ep17](https://www.youtube.com/watch?v=u1DoR5-76Xc&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=17): Add loading indicator when the video is loading. Add play and pause button. 

Add constraint with the new way 

	activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

or 

	pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
	
Detect when the video finished loading

	player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
			// video is ready. Do what you want :)
        }
    }
	
[Ep18](https://www.youtube.com/watch?v=HX1aYzaHex8&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=18): Add a duration slider and duration label for video. Drag the slider and seek to time in video player. 

Custom the slider color. 

	slider.minimumTrackTintColor = .red 						// left side of the thumb
    slider.maximumTrackTintColor = .white						// right side of the thumb

Display video duration

	if let duration = player?.currentItem?.duration {        
        let seconds = CMTimeGetSeconds(duration)
        let secondText = String(format: "%02d", Int(seconds) % 60)
        let minuteText = String(format: "%02d", Int(seconds) / 60)
        videoLengthLabel.text = "\(minuteText):\(secondText)"
    }

Seek to position in video by dragging the slider 

	let totalSeconds = CMTimeGetSeconds(duration)
    let value = Float64(videoSlider.value) * totalSeconds
    let seekTime = CMTime(value: Int64(value), timescale: 1)
    player?.seek(to: seekTime, completionHandler: { (completedSeek) in
        // something goes here
    })

[Ep19](https://www.youtube.com/watch?v=HwI9YF6i3DM&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=19): Track the player progress and add gradient layer at the bottom of the player view. 

Get the player progress and update the current time label and change the slider thumb. 

	player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            
        let seconds = CMTimeGetSeconds(progressTime)
        let secondString = String(format: "%02d", Int(seconds) % 60)
        let minuteString = String(format: "%02d", Int(seconds) / 60)
        self.currentTimeLabel.text = "\(minuteString):\(secondString)"
        
        // update the slider thumb 
        if let duration = self.player?.currentItem?.duration {
            let durationSeconds = CMTimeGetSeconds(duration)
            self.videoSlider.value = Float(seconds / durationSeconds)
        }
    })
    
Add gradient layer. Rememeber: the layer uses cgColor instead of uiColor. And the location is 0 from the top. 

	private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.red.cgColor]
        gradientLayer.locations = [0.7, 1.2] 
        controlsContainerView.layer.addSublayer(gradientLayer)
    }
	    
The project is drop here with basic layout and features. I learnt a lot from this project. I will come back and finish it later. 

Thanks a lot, Brain Voong. 

