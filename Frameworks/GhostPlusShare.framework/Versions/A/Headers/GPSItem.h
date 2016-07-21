//
//  GPSItem.h
//  GhostPlusShare
//
//  Created by VANSTUDIO on 2016. 3. 17..
//  Copyright © 2016년 GhostPlus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPSItem : NSObject
@property (nonatomic, strong) NSURL *contentURL;
@property (nonatomic, strong) NSString *contentTitle;
@property (nonatomic, strong) NSString *contentDescription;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSArray<NSString *> *tags;
@end
