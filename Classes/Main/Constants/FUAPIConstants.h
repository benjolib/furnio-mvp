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

#define FUAPIBaseURL @"http://api-furnio.makers.do"

#define FUAPIEndpoint(endpoint) [FUAPIBaseURL stringByAppendingString:endpoint]

#define FUAPIProducts FUAPIEndpoint(@"/products/list")
#define FUAPICategories FUAPIEndpoint(@"/categories/list")

#endif
