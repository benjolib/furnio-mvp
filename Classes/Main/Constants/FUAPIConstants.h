//
//  FUAPIConstants.h
//  furn
//
//  Created by Markus Bösch on 17/04/15.
//
//

#ifndef furn_FUAPIConstants_h
#define furn_FUAPIConstants_h

#import <JSONHTTPClient.h>

#define FUAPIBaseURL @"http://r1.runashop.com"
#define FUAPIEndpoint(endpoint) [FUAPIBaseURL stringByAppendingString:endpoint]

#define FUAPIProducts FUAPIEndpoint(@"/products/list")
#define FUAPICategories FUAPIEndpoint(@"/categories/list")

#endif
