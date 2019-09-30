//
//  Client.h
//  server_client
//
//  Created by Anna Vorobiova on 6/28/19.
//  Copyright © 2019 Anna Vorobiova. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Data;
@class Server;
@interface Client : NSObject

-(instancetype)initWithServer:(Server*)server;
-(NSArray*)receiveData:(NSError**)error;
-(NSError*)sendData:(Data*)data;

@end





