1.WBShareKey.h中修改配置信息

2.app delegate中添加

    - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
    {
        [[WBShareKit mainShare] handleOpenURL:url];   
        return YES;
    }
    
    - (void)sinaSuccess:(NSData *)_data
    {
        NSLog(@"sina ok:%@",_data);
    }

    - (void)sinaError:(NSError *)_error
    {
        NSLog(@"sina error:%@",_error);
    }
    
    //[[WBShareKit mainShare] startSinaOauthWithSelector:@selector(sinaSuccess:) withFailedSelector:@selector(sinaError:)];
    //如上认证代码添加的@selector也将会在此调用
    
3.在info.plist中修改url types

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <array>
    	<dict>
    		<key>CFBundleTypeRole</key>
    		<string>Editor</string>
    		<key>CFBundleURLName</key>
    		<string>minroad.com</string>
    		<key>CFBundleURLSchemes</key>
    		<array>
    			<string>oauth</string>
    		</array>
    	</dict>
    </array>
    </plist>

4.具体调用请查看WBShareKitViewController.m

更多信息

http://www.chlova.com

http://www.minroad.com