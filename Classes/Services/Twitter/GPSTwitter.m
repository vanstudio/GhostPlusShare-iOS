//
//  GPSTwitter.m
//  GhostPlusShare
//
//  Created by VANSTUDIO on 2016. 3. 21..
//  Copyright © 2016년 GhostPlus. All rights reserved.
//

#import "GPSTwitter.h"
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
//#import <Social/Social.h>

@interface GPSTwitter ()

@end

@implementation GPSTwitter

+ (NSString *)sharerTitle {
	return @"Twitter";
}

+ (BOOL)checkPrepare {
	BOOL result = YES;
	
	//////////////////////////////////////////////////////////////////////
	// Setting
	//////////////////////////////////////////////////////////////////////
	if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"Fabric"] == nil) {
		GPLogW(@"======================================================================");
		GPLogW(@"= %@ 관련 설정이 필요합니다.", [self sharerTitle]);
		GPLogW(@"======================================================================");
		GPLogW(@"= Febric 관련 추가 설정은 'https://fabric.io/kits/ios/twitterkit/install' 에서 확인하세요");
		GPLogW(@"======================================================================");
		GPLogW(@"= %@ 관련 Info.plist 설정", [self sharerTitle]);
		GPLogW(@"======================================================================");
		if ([GhostPlus useLog]) {
			printf("<key>Fabric</key>\n");
			printf("<dict>\n");
			printf("\t<key>APIKey</key>\n");
			printf("\t<string>트위터 APIKey</string>\n");
			printf("\t<key>Kits</key>\n");
			printf("\t<array>\n");
			printf("\t\t<dict>\n");
			printf("\t\t\t<key>KitInfo</key>\n");
			printf("\t\t\t<dict>\n");
			printf("\t\t\t\t<key>consumerKey</key>\n");
			printf("\t\t\t\t<string>트위터 Consumer Key</string>\n");
			printf("\t\t\t\t<key>consumerSecret</key>\n");
			printf("\t\t\t\t<string>트위터 Secret</string>\n");
			printf("\t\t\t</dict>\n");
			printf("\t\t\t<key>KitName</key>\n");
			printf("\t\t\t<string>Twitter</string>\n");
			printf("\t\t</dict>\n");
			printf("\t</array>\n");
			printf("</dict>\n");
		}
		GPLogW(@"======================================================================");
		result = NO;
	}
	
	return result;
}

+ (id)shareItem:(GPSItem *)item showFromViewController:(UIViewController *)fromViewController {
	GPLogI(@"item : %@", item);
	//GPLog(@"fromViewController : %@", fromViewController);
	GPSTwitter *controller = [self new];
	controller.item = item;
	[controller shareFromViewController:fromViewController];
	return controller;
}

+ (id)shareWithText:(NSString *)text tags:(NSArray<NSString *> *)tags image:(UIImage *)image linkURL:(NSURL *)linkURL showFromViewController:(UIViewController *)fromViewController {
	GPSItem *item = [GPSItem new];
	item.contentDescription = text;
	item.tags = tags;
	item.image = image;
	item.contentURL = linkURL;
	return [self shareItem:item showFromViewController:fromViewController];
}

+ (id)shareWithText:(NSString *)text tags:(NSArray<NSString *> *)tags imageURL:(NSURL *)imageURL linkURL:(NSURL *)linkURL showFromViewController:(UIViewController *)fromViewController {
	GPSItem *item = [GPSItem new];
	item.contentDescription = text;
	item.tags = tags;
	item.imageURL = imageURL;
	item.contentURL = linkURL;
	return [self shareItem:item showFromViewController:fromViewController];
}


#pragma mark - methods
- (void)shareFromViewController:(UIViewController *)fromViewController {
	GPLog(@"fromViewController : %@", fromViewController);
	
	// exception
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]] == NO) {
		[GPAlert showAlertWithTitle:[self.class sharerTitle] message:@"트위터 앱을 설치하신 후에 이용하실 수 있습니다." cancelButtonTitle:@"확인"];
		return;
	}
	
	//////////////////////////////////////////////////
	// Fabric - TwitterKit
	//////////////////////////////////////////////////
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		// init fabric
		[Fabric with:@[[Twitter class]]];
	});
	
	TWTRComposer *composer = [[TWTRComposer alloc] init];
	
	// TEXT & TAGS
	NSString *tagString = [self joinedTags];
	if (self.item.contentDescription) {
		if (tagString.length > 0) {
			[composer setText:[NSString stringWithFormat:@"%@ %@", self.item.contentDescription, tagString]];
		}
		else {
			[composer setText:self.item.contentDescription];
		}
	}
	else {
		if (tagString.length > 0) {
			[composer setText:tagString];
		}
	}
	
	// IMAGE
	if (self.item.contentURL == nil) {
		if (self.item.image) {
			[composer setImage:self.item.image];
		}
		else if (self.item.imageURL) {
			__block __weak __typeof(self) weakSelf = self;
			[UIImage loadImageInBackgroundWithURL:self.item.imageURL complete:^(UIImage *image) {
				__strong __typeof(weakSelf) strongSelf = weakSelf;
				if (!image) {
					GPLogE(@"image is nil");
					return;
				}
				strongSelf.item.image = image;
				[strongSelf shareFromViewController:fromViewController];
			}];
			return;
		}
	}
	
	// URL
	if (self.item.contentURL) {
		[composer setURL:self.item.contentURL];
	}
	
	// Called from a UIViewController
	[composer showFromViewController:fromViewController completion:^(TWTRComposerResult result) {
		if (result == TWTRComposerResultCancelled) {
			GPLog(@"Tweet composition cancelled");
		}
		else {
			GPLog(@"Sending Tweet!");
		}
	}];
	
	
	//////////////////////////////////////////////////
	// Social.framework
	// - Fabric 대체로 인해 사용안함
	//////////////////////////////////////////////////
	/*
	// twitter app available
	if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
		// exception - load image from url
		if (self.item.image == nil && self.item.imageURL != nil) {
			[UIImage loadImageInBackgroundWithURL:self.item.imageURL complete:^(UIImage *image) {
				self.item.image = image;
				self.item.imageURL = nil;
				[self shareFromViewController:fromViewController];
			}];
			return;
		}
		
		SLComposeViewController *twitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
		
		// IMAGE
		if (self.item.image) {
			BOOL addedImage = [twitter addImage:self.item.image];
			if (!addedImage) {
				[GPAlert showAlertWithTitle:[self.class sharerTitle] message:@"이미지 정보가 옳바르지 않습니다." cancelButtonTitle:@"확인"];
				return;
			}
		}
		
		// URL
		if (self.item.contentURL) {
			BOOL addedURL = [twitter addURL:self.item.contentURL];
			if (!addedURL) {
				[GPAlert showAlertWithTitle:[self.class sharerTitle] message:@"URL 정보가 옳바르지 않습니다." cancelButtonTitle:@"확인"];
				return;
			}
		}
		
		// TEXT & TAGS
		NSString *tagString = [self joinedTags];
		if (tagString.length > 0) {
			[twitter setInitialText:[NSString stringWithFormat:@"%@ %@", self.item.contentDescription, tagString]];
		}
		else {
			[twitter setInitialText:self.item.contentDescription];
		}
		
		// handler
		twitter.completionHandler = ^(SLComposeViewControllerResult result){
			switch (result) {
				case SLComposeViewControllerResultCancelled:
				{
					GPLog(@"SLComposeViewControllerResultCancelled");
				}
					break;
				case SLComposeViewControllerResultDone:
				{
					GPLog(@"SLComposeViewControllerResultDone");
				}
					break;
			}
		};
		[fromViewController presentViewController:twitter animated:YES completion:nil];
	}
	// twitter app not found
	else {
		[GPAlert showAlertWithTitle:[self.class sharerTitle] message:@"Twitter 앱을 설치하신 후에 이용하실 수 있습니다." cancelButtonTitle:@"확인"];
	}
	*/
}

- (NSString *)joinedTags {
	NSString *prefixString = @"#";
	NSString *joinString = @" ";
	NSMutableArray *cleanedTags = [NSMutableArray arrayWithCapacity:[self.item.tags count]];
	NSCharacterSet *removeSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
	
	for (NSString *tag in self.item.tags) {
		
		NSString *strippedTag;
		if (removeSet) {
			strippedTag = [[tag componentsSeparatedByCharactersInSet:removeSet] componentsJoinedByString:@""];
		} else {
			strippedTag = tag;
		}
		
		if ([strippedTag length] < 1) continue;
		strippedTag = [strippedTag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		if ([strippedTag length] < 1) continue;
		
		if ([prefixString length] > 0) {
			strippedTag = [prefixString stringByAppendingString:strippedTag];
		}
		
		[cleanedTags addObject:strippedTag];
	}
	
	if ([cleanedTags count] < 1) return @"";
	return [cleanedTags componentsJoinedByString:joinString];
}

@end
