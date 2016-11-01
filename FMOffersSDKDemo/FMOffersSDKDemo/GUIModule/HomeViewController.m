//
//  HomeViewController.m
//  FMOffersSDKDemo
//
//  Created by Nazmul on 11/1/16.
//  Copyright © 2016 zinnuree. All rights reserved.
//

#import "HomeViewController.h"
#import "OffersTableViewController.h"

#import "FMDataValidator.h"



@interface HomeViewController ()

//Made public to allow UI test
//@property (nonatomic, weak) IBOutlet UITextField *uidField;
//@property (nonatomic, weak) IBOutlet UITextField *apiKeyField;
//@property (nonatomic, weak) IBOutlet UITextField *appidField;

@end



#pragma mark - ViewController life-cycle

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"FMOffers SDK Demo";

    // assign prepopulated data
    self.uidField.text = @"spiderman";
    self.apiKeyField.text = @"1c915e3b5d42d05136185030892fbb846c278927";
    self.appidField.text = @"2070";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([identifier isEqualToString:@"ViewOffers"]) {
        
        // data validation
        NSError *validationError = nil;
        
        // validate user id field data
        BOOL userIdValid = [FMDataValidator validateUserId:_uidField.text error:&validationError];
        if (!userIdValid) {
            [self showValidationError:validationError];
            return NO;
        }
        
        // validate api key field data
        BOOL apiKeyValid = [FMDataValidator validateAPIKey:_apiKeyField.text error:&validationError];
        if (!apiKeyValid) {
            [self showValidationError:validationError];
            return NO;
        }
        
        BOOL appIdValid = [FMDataValidator validateAppId:_appidField.text error:&validationError];
        if (!appIdValid) {
            [self showValidationError:validationError];
            return NO;
        }
        
        // reached here, means all data valid, we should should show offers page
        return YES;
    }
    
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ViewOffers"]) {
        
        // reached here, means all data valid, we should should show offers page
        OffersTableViewController *viewController = segue.destinationViewController;
        
        // before that pass the collected values of uid, apiKey and appId
        viewController.userId = _uidField.text;
        viewController.apiKey = _apiKeyField.text;
        viewController.appId = _appidField.text;
        
        // now the transition will occur as indicated in the main storyboard
    }
}


#pragma mark - Alert

/**
 Shows all possible validation error as alert controller

 @param error The error description object
 */
- (void)showValidationError:(NSError*)error {
    
    // default error message in case this method is called with a nil parameter
    NSString *errorMessage = @"Unknown error";
    if (error) {
        errorMessage = error.localizedDescription;
    }
    
    // initiate the view
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Validation Failed"
                                                                             message:errorMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    // add action so that we can cancel the alert
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    // display
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
