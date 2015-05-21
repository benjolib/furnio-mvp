//
//  FUMacros.h
//  furn
//
//  Created by Stephan Krusche on 19/04/15.
//
//

#ifndef furn_FUMacros_h
#define furn_FUMacros_h

#define DEVICE_WIDTH deviceScreenWidth()
#define DEVICE_HEIGHT deviceScreenHeight()

static CGFloat deviceScreenWidth()
{
    static CGFloat screenWidth;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        screenWidth = screenRect.size.width;
    });
    return screenWidth;
}

static CGFloat deviceScreenHeight()
{
    static CGFloat screenHeight;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        screenHeight = screenRect.size.height;
    });
    return screenHeight;
}

#endif
