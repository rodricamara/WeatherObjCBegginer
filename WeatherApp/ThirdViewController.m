//
//  ThirdViewController.m
//  WeatherApp
//
//  Created by Rodrigo Cámara Robles on 5/27/19.
//  Copyright © 2019 Rodrigo Cámara Robles. All rights reserved.
//

#import "ThirdViewController.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "CustomTableViewCell.h"
#import "Masonry.h"

static NSString *CellIdentifier = @"WeatherCell";

@interface ThirdViewController ()

@property(nonatomic, strong) NSDictionary *response;
@property(nonatomic, strong) NSString *city;
@property (strong, nonatomic) UITableView *tableView;

@end


@implementation ThirdViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self obtenerDatosWeatherAPI];
    [self initializeTableview];
    
}

- (void) initializeTableview {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    
//    _tableView.dataSource = self;
//    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.greaterThanOrEqualTo(self.view.mas_bottom);
    }];
}




- (void)guardarVariables {
    NSString *country = [[self.response objectForKey:kSys] objectForKey:kCountry];
    NSString *nameCity = [self.response objectForKey:kName];
    NSString *temp = [[self.response objectForKey:kMain] objectForKey:kTemp];
    NSString *humidity = [[self.response objectForKey:kMain] objectForKey:kHumidity];
    
    NSArray *arrayData = [NSArray arrayWithObjects: country, nameCity, temp, humidity,nil];
    
    //Acceder e imprimir al elemento 1 del array
    //NSLog(@"%@", [arrayData objectAtIndex: 1]);
    
    //Imprimir contentido del array completo
    NSLog(@"%@", arrayData);
}

- (void)obtenerDatosWeatherAPI {
    
    NSString *cityWithEncoding = [self.city stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *url = [NSString stringWithFormat: @"http://api.openweathermap.org/data/2.5/weather?q=%@&lang=es&units=metric&appid=%@",cityWithEncoding, kApiKey];
    
    [self AFHttpManager:url andSuccesBlock:^(id responseObject) {
        self.response = responseObject;
        [self guardarVariables];
    }];
}

- (void)AFHttpManager:(NSString *)url andSuccesBlock:(void(^)(id response))success {
    NSDictionary __block *response;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET: url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        response = responseObject;
        success(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(instancetype)initWithCity:(NSString *)city {
    self = [super init];
    if (self) {
        self.city = city;
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
