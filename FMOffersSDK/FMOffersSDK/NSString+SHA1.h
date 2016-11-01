//
//  NSString+SHA1.h
//  FMOffersSDK
//
//  Created by Nazmul on 11/1/16.
//  Copyright © 2016 zinnuree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SHA1)

/**
 Wikipedia Article on SHA1 @ https://en.wikipedia.org/wiki/SHA-1
 
 Current Implementation @ http://stackoverflow.com/questions/7570377/creating-sha1-hash-from-nsstring
 
 All other hash functions @ https://github.com/hypercrypt/NSString-Hashes
 
 @return Secure Hash Value using SHA1
 */
-(NSString*)sha1;

@end
