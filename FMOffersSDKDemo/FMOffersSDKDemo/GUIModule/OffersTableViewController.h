//
//  OffersTableViewController.h
//  FMOffersSDKDemo
//
//  Created by Nazmul on 11/1/16.
//  Copyright © 2016 zinnuree. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 The only input form for the demo application, usually shows immediate after the app is launched
 */
@interface OffersTableViewController : UITableViewController {
    
    // api call state variables for the first API call
    BOOL initialLoadingInProgress;
    BOOL initialLoadingFailed;
    
    // api call state variables for the secndary API call
    BOOL appendingInProgress;
    BOOL appendingFailed;
    
    int currentPage;
    NSMutableArray *offers;
}

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *appId;

@property (nonatomic, strong) IBOutlet UIView *footerView;
@property (nonatomic, strong) IBOutlet UILabel *footerLabel;

@end

