//
//  GPSFacebook.h
//  GhostPlusShare
//
//  Created by VANSTUDIO on 2016. 3. 21..
//  Copyright © 2016년 GhostPlus. All rights reserved.
//

#import <GhostPlusShare/GhostPlusShare.h>

@interface GPSFacebook : GPSSharer

+ (id)shareWithLinkURL:(NSURL *)linkURL showFromViewController:(UIViewController *)fromViewController;
+ (id)shareWithImage:(UIImage *)image showFromViewController:(UIViewController *)fromViewController;
+ (id)shareWithImageURL:(NSURL *)imageURL showFromViewController:(UIViewController *)fromViewController;

@end
