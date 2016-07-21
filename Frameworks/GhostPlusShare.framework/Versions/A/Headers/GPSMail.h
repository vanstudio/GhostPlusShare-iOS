//
//  GPSMail.h
//  GhostPlusShare
//
//  Created by VANSTUDIO on 2016. 3. 24..
//  Copyright © 2016년 GhostPlus. All rights reserved.
//

#import <GhostPlusShare/GhostPlusShare.h>

@interface GPSMail : GPSSharer

+ (id)shareWithTitle:(NSString *)title text:(NSString *)text linkURL:(NSURL *)linkURL showFromViewController:(UIViewController *)fromViewController;

@end
