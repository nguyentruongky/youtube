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

- The 1st day ([Ep1](https://youtu.be/3Xv1mJvwXok)): Built the home screen with collection view.
		
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
    
- The 2nd day ([Ep2](https://youtu.be/APQVltARKF8) and [Ep3](https://youtu.be/rRhJGnSmEKQ)): Add dummy data and format cell size. Custom the navigation bar and status bar. Create a custom menu bar with UICollectionView. Change to image tint color.

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

- The 3rd day ([Ep4](https://youtu.be/Zud56x_VYvs)): Add dummy data, estimate the title size to change the title label height dynamically. Create 2 bar buttons and change their color. 

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
                
- The 4th day ([Ep5](https://youtu.be/WjrvcGAZfoI), [Ep6](https://www.youtube.com/watch?v=XFvs6eraBXM)): Working with the JSON. Call the service, get the result and parse JSON to the model. Extend the UIImageView to download image with GCD. Ep6 shows a solution to solve loading wrong image in UITableView/UICollectionView scrolling. Use cache and check the url before use the cache is a good idea. 

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
		
-
		// Cache image 
		let imageCache = NSCache<AnyObject, AnyObject>()
		
		// in load image function. Check the image loaded in cache 
		imageUrl = urlString
		    
		image = nil
		    
		if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
		    image = imageFromCache
		    return
		}
		// save image to cache 
		let imageToCache = UIImage(data: data!)
		        
		if self.imageUrl == urlString {
		    self.image = imageToCache
		}
		    
		imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
		self.image = imageToCache
		
- Update later...

