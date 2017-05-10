//
//  GPSNaverBand.h
//  GhostPlusShare
//
//  Created by VANSTUDIO on 2017. 4. 11..
//  Copyright © 2017년 GhostPlus. All rights reserved.
//

#import <GhostPlusShare/GhostPlusShare.h>

@interface GPSNaverBand : GPSSharer

+ (id)shareWithText:(NSString *)text route:(NSString *)route;

@end

@interface GPSNaverBandItem : GPSItem
@property (nonatomic, strong) NSString *route;
@end
