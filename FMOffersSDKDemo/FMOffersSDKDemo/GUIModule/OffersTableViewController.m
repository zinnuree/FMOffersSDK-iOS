//
//  OffersTableViewController.m
//  FMOffersSDKDemo
//
//  Created by Nazmul on 11/1/16.
//  Copyright © 2016 zinnuree. All rights reserved.
//


// the SDK's umbrella header
#import <FMOffersSDK/FMOffersSDK.h>

// GUI classes
#import "OffersTableViewController.h"
#import "FMOfferTableViewCell.h"
#import "FMErrorTableViewCell.h"

// import the image cache handler
#import "FMImageKeeper.h"



@interface OffersTableViewController ()

@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic) int pageCount;

@end



@implementation OffersTableViewController


#pragma mark - ViewController life-cycle

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        offers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        offers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Offers";
    
    [self.footerView removeFromSuperview];
    
    // must do it before making any call to the SDK
    [[FMOfferManager sharedInstance] initializeWithAppId:self.appId userId:self.userId apiKey:self.apiKey];
    
    //start loading data for the first page
    [self startDownloadingOffersForFirstPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)startDownloadingOffersForFirstPage {
    
    currentPage = 1;
    initialLoadingInProgress = YES;
    initialLoadingFailed = NO;
    
    [offers removeAllObjects];
    
    FMOfferDownloadCompletionHandler completionHandler;
    completionHandler = ^(NSArray *offersArray, FMOfferInformation *information, NSString *code, NSString *message, int offersCount, int pageCount, NSError *error) {
        
        initialLoadingInProgress = NO;
        
        if (error) {
            initialLoadingFailed = YES;
            self.errorMessage = error.localizedDescription;
            return;
        }
        
        self.pageCount = pageCount;
        [offers addObjectsFromArray:offersArray];
        
        [self.tableView reloadData];
    };
    
    [[FMOfferManager sharedInstance] downloadOffersWithCompletionHandler:completionHandler];
}


- (void)startDownloadingOffersForNextPage {
    
    // if one process is already in the queue, do not allow more
    if (appendingInProgress) {
        return;
    }
    
    // if the last page is already loaded
    if (currentPage >= self.pageCount) {
        return;
    }
    
    appendingInProgress = YES;
    appendingFailed = NO;
    
    [self.tableView reloadData];
    
    FMOfferAppendCompletionHandler completionHandler;
    completionHandler = ^(NSArray *offersArray, FMOfferInformation *information, NSString *code, NSString *message, int offersCount, NSError *error) {
        
        appendingInProgress = NO;
        
        if (error) {
            appendingFailed = YES;
            self.errorMessage = error.localizedDescription;
            return;
        }
        
        currentPage += 1;
        [offers addObjectsFromArray:offersArray];
        
        [self.tableView reloadData];
    };
    
    [[FMOfferManager sharedInstance] downloadOffersForPageNumber:(currentPage + 1) completionHandler:completionHandler];
}


#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if([scrollView isEqual:self.tableView]) {
        
        if (currentPage < self.pageCount) {
            
            if(scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height) {
                
                [self startDownloadingOffersForNextPage];
            }
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (initialLoadingInProgress) {
        return 1;
    }
    
    if (initialLoadingFailed) {
        return 1;
    }
    
    //check whether offers arrays is empty
    if (offers.count == 0) {
        return 1;
    }
    
    // otherwise return offers count here
    return offers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (currentPage >= self.pageCount) {
        return 0;
    }
    
    if (appendingInProgress) {
        self.footerLabel.text = @"Loading...";
        return 36;
    }
    
    if (appendingFailed) {
        self.footerLabel.text = self.errorMessage;
        return 36;
    }
    
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (currentPage >= self.pageCount) {
        return nil;
    }
    
    if (appendingInProgress) {
        self.footerLabel.text = @"Loading...";
        return self.footerView;
    }
    
    if (appendingFailed) {
        self.footerLabel.text = self.errorMessage;
        return self.footerView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (initialLoadingInProgress) {
        return tableView.bounds.size.height;
    }
    
    if (initialLoadingFailed) {
        return tableView.bounds.size.height;
    }
    
    //check whether offers arrays is empty
    if (offers.count == 0) {
        return tableView.bounds.size.height;
    }
    
    // otherwise return generic height necessary to show offer
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (initialLoadingInProgress) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loadingCell"];
        return cell;
    }
    
    if (initialLoadingFailed) {
        FMErrorTableViewCell *cell = (FMErrorTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"errorCell"];
        cell.errorMessageLabel.text = self.errorMessage;
        return cell;
    }
    
    //check whether offers arrays is empty
    if (offers.count == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noDataCell"];
        return cell;
    }
    
    FMOfferTableViewCell *cell = (FMOfferTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"offerCell"];
    
    //Configure the cell...
    FMOffer *offer = [offers objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = offer.title;
    cell.teaserLabel.text = offer.teaser;
    cell.payoutLabel.text = [NSString stringWithFormat:@"Payout: %d", offer.payout];
    
    UIImage *thumbnail = [[FMImageKeeper sharedInstance] imageForOfferId:0];
    if (thumbnail) {
        cell.thumbnailView.image = thumbnail;
    }
    else {
        
        //asychronously download thumbnail image, also cache image to avoid frequent download
        [[FMImageKeeper sharedInstance] downloadImageForOfferId:0 url:offer.thumbnail.highResolutionURLString completion:^(UIImage *image) {
        
            // whether the image was actually downloaded
            if (image) {
                
                // now set the image to the cell
                cell.thumbnailView.image = image;
            }
        }];
    }
    
    return cell;
}

@end
