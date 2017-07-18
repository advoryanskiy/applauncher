//
//  ALApp.m
//  applauncher
//
//  Created by Aleksey Dvoryanskiy on 4/12/17.
//  Copyright © 2017 none. All rights reserved.
//

#import "ALApp.h"

@interface UIImage()

+ (id)_iconForResourceProxy:(id)arg1 variant:(int)arg2 variantsScale:(float)arg3;
+ (id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2 scale:(double)arg3;

@end

#pragma mark -

@interface PrivateApi_LSApplicationProxy

+ (instancetype)applicationProxyForIdentifier:(NSString*)identifier;

@property (nonatomic, readonly) NSString* localizedShortName;
@property (nonatomic, readonly) NSString* localizedName;
@property (nonatomic, readonly) NSString* bundleIdentifier;
@property (nonatomic, readonly) NSArray* appTags;

@end


@interface ALApp() {
    UIImage *_icon;
}

@property (nonatomic, retain) PrivateApi_LSApplicationProxy *appProxy;

@end

@implementation ALApp

- (NSString *)bundleIdentifier {
    return [self.appProxy bundleIdentifier];
}

- (NSString *)name {
    return self.appProxy.localizedName ?: self.appProxy.localizedShortName ?: self.appProxy.bundleIdentifier;
}

- (UIImage *)icon {
    if (_icon == nil) {
        _icon = [UIImage _applicationIconImageForBundleIdentifier:self.bundleIdentifier format:10 scale:2.0];
    }
    
    return _icon;
}

- (BOOL)isHidden {
    return [self.appProxy.appTags indexOfObject:@"hidden"] != NSNotFound;
}

- (id)initWithPrivateProxy:(id)privateProxy {
    if ((self = [super init])) {
        self.appProxy = (PrivateApi_LSApplicationProxy *)privateProxy;
    }
    
    return self;
}

+ (instancetype)appWithPrivateProxy:(id)privateProxy {
    return [[self alloc] initWithPrivateProxy:privateProxy];
}

@end
