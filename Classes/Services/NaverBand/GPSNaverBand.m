//
//  GPSNaverBand.m
//  GhostPlusShare
//
//  Created by VANSTUDIO on 2017. 4. 11..
//  Copyright © 2017년 GhostPlus. All rights reserved.
//

#import "GPSNaverBand.h"

@interface GPSNaverBand ()

@end

@implementation GPSNaverBand
+ (NSString *)sharerTitle {
	return @"네이버밴드";
}

+ (BOOL)checkPrepare {
	BOOL result = YES;
	
	//////////////////////////////////////////////////////////////////////
	// LSApplicationQueriesSchemes
	//////////////////////////////////////////////////////////////////////
	NSMutableArray *needRegisterSchemes = [NSMutableArray new];
	NSArray *LSApplicationQueriesSchemes = @[
											 @"bandapp",
											 ];
	
	for (NSString *scheme in LSApplicationQueriesSchemes) {
		if ([[GPApplicationManager sharedManager] isRegisteredCanOpenURLScheme:scheme] == NO) {
			[needRegisterSchemes addObject:scheme];
		}
	}
	
	if (needRegisterSchemes.count > 0) {
		GPLogW(@"======================================================================");
		GPLogW(@"= %@ LSApplicationQueriesSchemes 설정이 필요합니다.", [self sharerTitle]);
		GPLogW(@"= Info.plist 에 아래 항목을 추가해주세요");
		GPLogW(@"======================================================================");
		if ([GhostPlus useLog]) {
			printf("<key>LSApplicationQueriesSchemes</key>\n");
			printf("<array>\n");
			for (NSString *scheme in needRegisterSchemes) {
				printf("\t<string>%s</string>\n", [scheme UTF8String]);
			}
			printf("</array>\n");
		}
		GPLogW(@"======================================================================");
		result = NO;
	}
	
	return result;
}

+ (id)shareItem:(GPSItem *)item showFromViewController:(UIViewController *)fromViewController {
	GPLogI(@"item : %@", item);
	//GPLog(@"fromViewController : %@", fromViewController);
	GPSNaverBand *controller = [self new];
	controller.item = item;
	[controller share];
	return controller;
}

+ (id)shareWithText:(NSString *)text route:(NSString *)route {
	GPSNaverBandItem *item = [GPSNaverBandItem new];
	item.contentTitle = text;
	item.route = route;
	return [self shareItem:item showFromViewController:nil];
}


#pragma mark - methods
- (void)share {
	GPSNaverBandItem *item = (GPSNaverBandItem *)self.item;
	
	// exception
	if (item.contentTitle == nil && item.route == nil) {
		GPLogW(@"공유 할 내용이 없습니다.");
		return;
	}
	
	// share
	
	NSString *text = item.contentTitle;
	NSString *route = item.route;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"bandapp://create/post?text=%@&route=%@", [text URLEncode], [route URLEncode]]];
	GPLog(@"url : %@", url);
	if ([[UIApplication sharedApplication] canOpenURL:url]) {
		[[UIApplication sharedApplication] openURL:url];
	}
	else {
		[GPAlert showAlertWithTitle:[self.class sharerTitle] message:@"네이버밴드 앱을 설치하신 후에 이용하실 수 있습니다." cancelButtonTitle:@"확인"];
	}
}

@end


@implementation GPSNaverBandItem

- (NSString *)description {
	return [NSString stringWithFormat:@"%@\nroute : %@", [super description], self.route];
}

@end
