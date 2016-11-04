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
    
    // current page index, starting from 1
    int currentPage;
    
    // the editable list of offers
    NSMutableArray *offers;
}

/**
 The user id (uid in both API call and in the input UI)
 */
@property (nonatomic, strong) NSString *userId;

/**
 The api key (apikey in the API call and in the input UI)
 */
@property (nonatomic, strong) NSString *apiKey;

/**
 The app id
 */
@property (nonatomic, strong) NSString *appId;


#pragma mark - Interface builder outlets

@property (nonatomic, strong) IBOutlet UIView *footerView;
@property (nonatomic, strong) IBOutlet UILabel *footerLabel;

@end

