//
//  UserReponsitory.h
//  BasetaxPlus
//
//  Created by Hung Kiet Ngo on 12/7/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserReponsitory : NSObject

@property (nonatomic, retain)NSString* userName;
@property (nonatomic, retain)NSString* password;
@property (nonatomic, retain)NSString* userID;
@property (nonatomic, retain)NSString* displayName;
@property (nonatomic, retain)NSString* email;
@property (nonatomic, retain)UIImage* imageUser;

@end
