//
//  FlickrViewController.h
//  TEDxAlcatraz
//
//  Created by Peter Ma on 8/9/11.
//  Copyright (c) 2011 Catch.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoomedImageView.h"

@interface FlickrViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UITableView     *theTableView;
    NSMutableArray  *photoTitles;         // Titles of images
    NSMutableArray  *photoSmallImageData; // Image data (thumbnail)
    NSMutableArray  *photoURLsLargeImage; // URL to larger image
    
    ZoomedImageView  *fullImageViewController;
    UIActivityIndicatorView *activityIndicator;      
}


@end
