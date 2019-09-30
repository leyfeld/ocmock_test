#import <Foundation/Foundation.h>

enum Sex{
    man = 1,
    women
};

@interface Data : NSObject

@property(nonatomic, strong)NSString* name;
@property(nonatomic, strong)NSArray<NSString*>* pets;
@property(nonatomic)enum Sex type;

@end


