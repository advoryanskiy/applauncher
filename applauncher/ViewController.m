//
//  ViewController.m
//  applauncher
//
//  Created by Aleksey Dvoryanskiy on 4/12/17.
//  Copyright © 2017 none. All rights reserved.
//

#import "ViewController.h"
#import "ALApp.h"

@interface PrivateApi_LSApplicationWorkspace : NSObject

- (NSArray *)allInstalledApplications;
- (BOOL)openApplicationWithBundleID:(id)arg1;

@end


@interface ViewController ()

@property (nonatomic, retain) PrivateApi_LSApplicationWorkspace *workspace;
@property (nonatomic, retain) NSMutableArray *apps;

@end

@implementation ViewController

- (instancetype)init {
    if ((self = [super init])) {
        self.workspace = [NSClassFromString(@"LSApplicationWorkspace") new];
        self.apps = [NSMutableArray new];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.workspace = [NSClassFromString(@"LSApplicationWorkspace") new];
        self.apps = [NSMutableArray new];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.workspace respondsToSelector:@selector(allInstalledApplications)]) {
        NSArray *allApps = [self.workspace allInstalledApplications];
        for (id appProxy in allApps) {
            ALApp *app = [ALApp appWithPrivateProxy:appProxy];
            
            if (!app.isHidden) {
                [self.apps addObject:app];
            }
        }
        NSLog(@"Apps: %@", allApps);
    } else {
        NSLog(@"LSApplicationWorkspace doesn't have '-(NSArray*)allInstalledApplications' method");
    }
    
    if (self.apps.count == 0) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to load apps list from LSApplicationWorkspace for some reason. See logs." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [errorAlert show];
    }
    
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark UITableView delegate and data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.apps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    ALApp *app = [self.apps objectAtIndex:indexPath.row];
    
    cell.imageView.image = app.icon;
    cell.textLabel.text = app.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ALApp *app = [self.apps objectAtIndex:indexPath.row];
    
    if ([self.workspace respondsToSelector:@selector(openApplicationWithBundleID:)]) {
        [self.workspace openApplicationWithBundleID:app.bundleIdentifier];
    } else {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"LSApplicationWorkspace doesn't support '-(BOOL)openApplicationWithBundleID:(id)arg1' method on your device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [errorAlert show];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
