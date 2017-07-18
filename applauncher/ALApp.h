//
//  ALApp.h
//  applauncher
//
//  Created by Aleksey Dvoryanskiy on 4/12/17.
//  Copyright © 2017 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ALApp : NSObject

@property (nonatomic, readonly) NSString* bundleIdentifier;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) UIImage* icon;

@property (nonatomic, readonly) BOOL isHidden;

- (id)initWithPrivateProxy:(id)privateProxy;

+ (instancetype)appWithPrivateProxy:(id)privateProxy;

@end
