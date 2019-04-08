//
//  GPSTwitter.h
//  GhostPlusShare
//
//  Created by VANSTUDIO on 2016. 3. 21..
//  Copyright © 2016년 GhostPlus. All rights reserved.
//

#import <GhostPlusShare/GhostPlusShare.h>

@interface GPSTwitter : GPSSharer

+ (id)shareWithText:(NSString *)text tags:(NSArray<NSString *> *)tags image:(UIImage *)image linkURL:(NSURL *)linkURL showFromViewController:(UIViewController *)fromViewController;
+ (id)shareWithText:(NSString *)text tags:(NSArray<NSString *> *)tags imageURL:(NSURL *)imageURL linkURL:(NSURL *)linkURL showFromViewController:(UIViewController *)fromViewController;

@end
