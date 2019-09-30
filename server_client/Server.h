//
//  Server.h
//  server_client
//
//  Created by Anna Vorobiova on 6/28/19.
//  Copyright © 2019 Anna Vorobiova. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Server : NSObject

-(NSString*)getData:(NSError **)error;
-(NSError*)postData:(NSString*)data;


@end

