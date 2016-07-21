//
//  GPSMessage.h
//  GhostPlusShare
//
//  Created by VANSTUDIO on 2016. 3. 24..
//  Copyright © 2016년 GhostPlus. All rights reserved.
//

#import <GhostPlusShare/GhostPlusShare.h>

@interface GPSMessage : GPSSharer

+ (id)shareWithText:(NSString *)text linkURL:(NSURL *)linkURL showFromViewController:(UIViewController *)fromViewController;

@end
