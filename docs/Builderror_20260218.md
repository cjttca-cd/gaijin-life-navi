-------------------------------------
Translated Report (Full Report Below)
-------------------------------------
Process:             Runner [51536]
Path:                /Users/USER/Library/Developer/CoreSimulator/Devices/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4/data/Containers/Bundle/Application/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190/Runner.app/Runner
Identifier:          com.nebulainfinity.japanLifeNavi
Version:             0.1.0 (1)
Code Type:           ARM-64 (Native)
Role:                Foreground
Parent Process:      launchd_sim [8302]
Coalition:           com.apple.CoreSimulator.SimDevice.49D52B25-B21A-47E4-B8BD-CACC37D5FCA4 [174800]
Responsible Process: SimulatorTrampoline [95854]
User ID:             501

Date/Time:           2026-02-18 13:18:27.8026 +0900
Launch Time:         2026-02-18 13:18:26.7541 +0900
Hardware Model:      Mac15,6
OS Version:          macOS 26.2 (25C56)
Release Type:        User

Crash Reporter Key:  42E773A5-CE8E-1C2A-50CB-1171407FAD49
Incident Identifier: 064E502E-917E-4BFC-8CE4-F58838C11F98

Sleep/Wake UUID:       10A7EDF2-511B-4E65-997F-CCC746097EEB

Time Awake Since Boot: 2200000 seconds
Time Since Wake:       14597 seconds

System Integrity Protection: enabled

Triggered by Thread: 0, Dispatch Queue: com.apple.main-thread

Exception Type:    EXC_CRASH (SIGABRT)
Exception Codes:   0x0000000000000000, 0x0000000000000000

Termination Reason:  Namespace SIGNAL, Code 6, Abort trap: 6
Terminating Process: Runner [51536]


Last Exception Backtrace:
0   CoreFoundation                	       0x1804f71c4 __exceptionPreprocess + 160
1   libobjc.A.dylib               	       0x18009c094 objc_exception_throw + 72
2   CoreFoundation                	       0x1804f70e0 -[NSException initWithCoder:] + 0
3   FirebaseInstallations         	       0x101045a24 +[FIRInstallations validateAPIKey:] + 640 (FIRInstallations.m:162)
4   FirebaseInstallations         	       0x101045760 +[FIRInstallations validateAppOptions:appName:] + 668 (FIRInstallations.m:137)
5   FirebaseInstallations         	       0x101045358 -[FIRInstallations initWithAppOptions:appName:installationsIDController:prefetchAuthToken:] + 200 (FIRInstallations.m:91)
6   FirebaseInstallations         	       0x101045220 -[FIRInstallations initWithApp:] + 188 (FIRInstallations.m:78)
7   FirebaseInstallations         	       0x101045104 __40+[FIRInstallations componentsToRegister]_block_invoke + 132 (FIRInstallations.m:62)
8   FirebaseCore                  	       0x100f1abf0 -[FIRComponentContainer instantiateInstanceForProtocol:withBlock:] + 112 (FIRComponentContainer.m:161)
9   FirebaseCore                  	       0x100f1aedc -[FIRComponentContainer instanceForProtocol:] + 320 (FIRComponentContainer.m:200)
10  FirebaseCore                  	       0x100f1b85c +[FIRComponentType instanceForProtocol:inContainer:] + 92 (FIRComponentType.m:26)
11  FirebaseInstallations         	       0x101045b98 +[FIRInstallations installationsWithApp:] + 120 (FIRInstallations.m:192)
12  FirebaseInstallations         	       0x101045af4 +[FIRInstallations installations] + 124 (FIRInstallations.m:188)
13  Runner.debug.dylib            	       0x1012a6df0 +[FIRAnalytics updateFirebaseInstallationID] + 24
14  Runner.debug.dylib            	       0x1012a6d8c +[FIRAnalytics startWithConfiguration:options:] + 356
15  FirebaseCore                  	       0x100f16a8c -[FIRApp configureCore] + 304 (FIRApp.m:349)
16  FirebaseCore                  	       0x100f16624 +[FIRApp addAppToAppDictionary:] + 124 (FIRApp.m:304)
17  FirebaseCore                  	       0x100f159b4 +[FIRApp configureWithName:options:] + 1204 (FIRApp.m:187)
18  Runner.debug.dylib            	       0x10143f3a4 -[FLTFirebaseCorePlugin initializeAppAppName:initializeAppRequest:completion:] + 1740
19  Runner.debug.dylib            	       0x101443a14 __SetUpFirebaseCoreHostApiWithSuffix_block_invoke + 312
20  Flutter                       	       0x1049d85c8 __48-[FlutterBasicMessageChannel setMessageHandler:]_block_invoke + 160
21  Flutter                       	       0x1044fa5d8 invocation function for block in flutter::PlatformMessageHandlerIos::HandlePlatformMessage(std::__fl::unique_ptr<flutter::PlatformMessage, std::__fl::default_delete<flutter::PlatformMessage>>) + 108
22  libdispatch.dylib             	       0x1801c07a8 _dispatch_call_block_and_release + 24
23  libdispatch.dylib             	       0x1801db4b0 _dispatch_client_callout + 12
24  libdispatch.dylib             	       0x1801f74a0 <deduplicated_symbol> + 24
25  libdispatch.dylib             	       0x1801d031c _dispatch_main_queue_drain + 1184
26  libdispatch.dylib             	       0x1801cfe6c _dispatch_main_queue_callback_4CF + 40
27  CoreFoundation                	       0x180455ed8 __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__ + 12
28  CoreFoundation                	       0x1804550b0 __CFRunLoopRun + 1884
29  CoreFoundation                	       0x18044fcec _CFRunLoopRunSpecificWithOptions + 496
30  GraphicsServices              	       0x192a669bc GSEventRunModal + 116
31  UIKitCore                     	       0x186348574 -[UIApplication _run] + 772
32  UIKitCore                     	       0x18634c79c UIApplicationMain + 124
33  UIKitCore                     	       0x18557f2d0 0x18519e000 + 4068048
34  Runner.debug.dylib            	       0x1012a2a3c static UIApplicationDelegate.main() + 128
35  Runner.debug.dylib            	       0x1012a29ac static AppDelegate.$main() + 44
36  Runner.debug.dylib            	       0x1012a2ab8 __debug_main_executable_dylib_entry_point + 28
37  ???                           	       0x100e213d0 ???
38  dyld                          	       0x100c58d54 start + 7184

Thread 0 Crashed::  Dispatch queue: com.apple.main-thread
0   libsystem_kernel.dylib        	       0x1011b485c __pthread_kill + 8
1   libsystem_pthread.dylib       	       0x101a362a8 pthread_kill + 264
2   libsystem_c.dylib             	       0x1801b5994 abort + 100
3   libc++abi.dylib               	       0x18030326c __abort_message + 128
4   libc++abi.dylib               	       0x1802f31a4 demangling_terminate_handler() + 268
5   libobjc.A.dylib               	       0x180077218 _objc_terminate() + 124
6   libc++abi.dylib               	       0x180302758 std::__terminate(void (*)()) + 12
7   libc++abi.dylib               	       0x1803057c0 __cxxabiv1::failed_throw(__cxxabiv1::__cxa_exception*) + 32
8   libc++abi.dylib               	       0x1803057a0 __cxa_throw + 88
9   libobjc.A.dylib               	       0x18009c1cc objc_exception_throw + 384
10  CoreFoundation                	       0x1804f70e0 +[NSException raise:format:] + 124
11  FirebaseInstallations         	       0x101045a24 +[FIRInstallations validateAPIKey:] + 640 (FIRInstallations.m:162)
12  FirebaseInstallations         	       0x101045760 +[FIRInstallations validateAppOptions:appName:] + 668 (FIRInstallations.m:137)
13  FirebaseInstallations         	       0x101045358 -[FIRInstallations initWithAppOptions:appName:installationsIDController:prefetchAuthToken:] + 200 (FIRInstallations.m:91)
14  FirebaseInstallations         	       0x101045220 -[FIRInstallations initWithApp:] + 188 (FIRInstallations.m:78)
15  FirebaseInstallations         	       0x101045104 __40+[FIRInstallations componentsToRegister]_block_invoke + 132 (FIRInstallations.m:62)
16  FirebaseCore                  	       0x100f1abf0 -[FIRComponentContainer instantiateInstanceForProtocol:withBlock:] + 112 (FIRComponentContainer.m:161)
17  FirebaseCore                  	       0x100f1aedc -[FIRComponentContainer instanceForProtocol:] + 320 (FIRComponentContainer.m:200)
18  FirebaseCore                  	       0x100f1b85c +[FIRComponentType instanceForProtocol:inContainer:] + 92 (FIRComponentType.m:26)
19  FirebaseInstallations         	       0x101045b98 +[FIRInstallations installationsWithApp:] + 120 (FIRInstallations.m:193)
20  FirebaseInstallations         	       0x101045af4 +[FIRInstallations installations] + 124 (FIRInstallations.m:188)
21  Runner.debug.dylib            	       0x1012a6df0 +[FIRAnalytics updateFirebaseInstallationID] + 24
22  Runner.debug.dylib            	       0x1012a6d8c +[FIRAnalytics startWithConfiguration:options:] + 356
23  FirebaseCore                  	       0x100f16a8c -[FIRApp configureCore] + 304 (FIRApp.m:349)
24  FirebaseCore                  	       0x100f16624 +[FIRApp addAppToAppDictionary:] + 124 (FIRApp.m:304)
25  FirebaseCore                  	       0x100f159b4 +[FIRApp configureWithName:options:] + 1204 (FIRApp.m:187)
26  Runner.debug.dylib            	       0x10143f3a4 -[FLTFirebaseCorePlugin initializeAppAppName:initializeAppRequest:completion:] + 1740
27  Runner.debug.dylib            	       0x101443a14 __SetUpFirebaseCoreHostApiWithSuffix_block_invoke + 312
28  Flutter                       	       0x1049d85c8 __48-[FlutterBasicMessageChannel setMessageHandler:]_block_invoke + 160
29  Flutter                       	       0x1044fa5d8 invocation function for block in flutter::PlatformMessageHandlerIos::HandlePlatformMessage(std::__fl::unique_ptr<flutter::PlatformMessage, std::__fl::default_delete<flutter::PlatformMessage>>) + 108
30  libdispatch.dylib             	       0x1801c07a8 _dispatch_call_block_and_release + 24
31  libdispatch.dylib             	       0x1801db4b0 _dispatch_client_callout + 12
32  libdispatch.dylib             	       0x1801f74a0 <deduplicated_symbol> + 24
33  libdispatch.dylib             	       0x1801d031c _dispatch_main_queue_drain + 1184
34  libdispatch.dylib             	       0x1801cfe6c _dispatch_main_queue_callback_4CF + 40
35  CoreFoundation                	       0x180455ed8 __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__ + 12
36  CoreFoundation                	       0x1804550b0 __CFRunLoopRun + 1884
37  CoreFoundation                	       0x18044fcec _CFRunLoopRunSpecificWithOptions + 496
38  GraphicsServices              	       0x192a669bc GSEventRunModal + 116
39  UIKitCore                     	       0x186348574 -[UIApplication _run] + 772
40  UIKitCore                     	       0x18634c79c UIApplicationMain + 124
41  UIKitCore                     	       0x18557f2d0 0x18519e000 + 4068048
42  Runner.debug.dylib            	       0x1012a2a3c static UIApplicationDelegate.main() + 128
43  Runner.debug.dylib            	       0x1012a29ac static AppDelegate.$main() + 44
44  Runner.debug.dylib            	       0x1012a2ab8 __debug_main_executable_dylib_entry_point + 28
45  ???                           	       0x100e213d0 ???
46  dyld                          	       0x100c58d54 start + 7184

Thread 1:

Thread 2:

Thread 3:

Thread 4:

Thread 5:: com.apple.uikit.eventfetch-thread
0   libsystem_kernel.dylib        	       0x1011acb70 mach_msg2_trap + 8
1   libsystem_kernel.dylib        	       0x1011bd90c mach_msg2_internal + 72
2   libsystem_kernel.dylib        	       0x1011b4c10 mach_msg_overwrite + 480
3   libsystem_kernel.dylib        	       0x1011acee4 mach_msg + 20
4   CoreFoundation                	       0x180455c04 __CFRunLoopServiceMachPort + 156
5   CoreFoundation                	       0x180454dbc __CFRunLoopRun + 1128
6   CoreFoundation                	       0x18044fcec _CFRunLoopRunSpecificWithOptions + 496
7   Foundation                    	       0x18110be48 -[NSRunLoop(NSRunLoop) runMode:beforeDate:] + 208
8   Foundation                    	       0x18110c068 -[NSRunLoop(NSRunLoop) runUntilDate:] + 60
9   UIKitCore                     	       0x18609fc50 -[UIEventFetcher threadMain] + 392
10  Foundation                    	       0x181132d14 __NSThread__start__ + 716
11  libsystem_pthread.dylib       	       0x101a365ac _pthread_start + 104
12  libsystem_pthread.dylib       	       0x101a31998 thread_start + 8

Thread 6::  Dispatch queue: com.google.fira.worker
0   libsystem_kernel.dylib        	       0x1011ad6e8 __open_nocancel + 8
1   libsystem_kernel.dylib        	       0x1011bfee0 open$NOCANCEL + 72
2   libsystem_c.dylib             	       0x18017b0a4 fopen + 128
3   libsystem_info.dylib          	       0x1803a1df8 _fsi_get_group + 88
4   libsystem_info.dylib          	       0x1803ab138 search_group_bygid + 72
5   libsystem_info.dylib          	       0x1803a7ae8 getgrgid_r + 100
6   Foundation                    	       0x180eb0194 specialized closure #1 in static Platform.withUserGroupBuffer<A, B, C>(_:_:sizeProperty:operation:block:) + 96
7   Foundation                    	       0x180eb036c specialized static Platform.name(forGID:) + 336
8   Foundation                    	       0x180c24938 closure #1 in _FileManagerImpl.attributesOfItem(atPath:) + 3784
9   Foundation                    	       0x180c182b0 partial apply for closure #1 in _FileManagerImpl.attributesOfItem(atPath:) + 20
10  Foundation                    	       0x180e3e4fc specialized String.withFileSystemRepresentation<A>(_:) + 184
11  Foundation                    	       0x180c12420 specialized NSFileManager.withFileSystemRepresentation<A>(for:_:) + 208
12  Foundation                    	       0x180c13508 @objc _NSFileManagerBridge.attributesOfItem(atPath:) + 140
13  Runner.debug.dylib            	       0x1013f9320 -[APMSqliteStore openAndValidateDatabase:] + 100
14  Runner.debug.dylib            	       0x1013f5998 -[APMSqliteStore initWithDatabasePath:error:] + 184
15  Runner.debug.dylib            	       0x10136d128 -[APMDatabase initializeDatabaseResourcesWithContext:databasePath:error:] + 88
16  Runner.debug.dylib            	       0x101364108 -[APMDatabase initWithDatabaseName:persistedConfig:error:] + 172
17  Runner.debug.dylib            	       0x10138daac __47-[APMMeasurement startMeasurementOnWorkerQueue]_block_invoke + 452
18  Runner.debug.dylib            	       0x10138d820 -[APMMeasurement startMeasurementOnWorkerQueue] + 140
19  Runner.debug.dylib            	       0x10138d1ac -[APMMeasurement setEnabledOnWorkerQueue:] + 168
20  Runner.debug.dylib            	       0x10138d0f4 __29-[APMMeasurement setEnabled:]_block_invoke + 36
21  Runner.debug.dylib            	       0x1013efdf4 __51-[APMScheduler scheduleOnWorkerQueueBlockID:block:]_block_invoke + 44
22  libdispatch.dylib             	       0x1801c07a8 _dispatch_call_block_and_release + 24
23  libdispatch.dylib             	       0x1801db4b0 _dispatch_client_callout + 12
24  libdispatch.dylib             	       0x1801c9c28 _dispatch_lane_serial_drain + 984
25  libdispatch.dylib             	       0x1801ca6e8 _dispatch_lane_invoke + 396
26  libdispatch.dylib             	       0x1801d5534 _dispatch_root_queue_drain_deferred_wlh + 288
27  libdispatch.dylib             	       0x1801d4c74 _dispatch_workloop_worker_thread + 692
28  libsystem_pthread.dylib       	       0x101a32b8c _pthread_wqthread + 288
29  libsystem_pthread.dylib       	       0x101a3198c start_wqthread + 8

Thread 7:

Thread 8:

Thread 9:

Thread 10:

Thread 11::  Dispatch queue: APMExperimentWorkerQueue
0   libsystem_kernel.dylib        	       0x1011ad6e8 __open_nocancel + 8
1   libsystem_kernel.dylib        	       0x1011bfee0 open$NOCANCEL + 72
2   libsystem_c.dylib             	       0x18017b0a4 fopen + 128
3   libsystem_info.dylib          	       0x1803a1df8 _fsi_get_group + 88
4   libsystem_info.dylib          	       0x1803ab138 search_group_bygid + 72
5   libsystem_info.dylib          	       0x1803a7ae8 getgrgid_r + 100
6   Foundation                    	       0x180eb0194 specialized closure #1 in static Platform.withUserGroupBuffer<A, B, C>(_:_:sizeProperty:operation:block:) + 96
7   Foundation                    	       0x180eb036c specialized static Platform.name(forGID:) + 336
8   Foundation                    	       0x180c24938 closure #1 in _FileManagerImpl.attributesOfItem(atPath:) + 3784
9   Foundation                    	       0x180c182b0 partial apply for closure #1 in _FileManagerImpl.attributesOfItem(atPath:) + 20
10  Foundation                    	       0x180e3e4fc specialized String.withFileSystemRepresentation<A>(_:) + 184
11  Foundation                    	       0x180c12420 specialized NSFileManager.withFileSystemRepresentation<A>(for:_:) + 208
12  Foundation                    	       0x180c13508 @objc _NSFileManagerBridge.attributesOfItem(atPath:) + 140
13  Runner.debug.dylib            	       0x1013f9320 -[APMSqliteStore openAndValidateDatabase:] + 100
14  Runner.debug.dylib            	       0x1013f5998 -[APMSqliteStore initWithDatabasePath:error:] + 184
15  Runner.debug.dylib            	       0x101371694 -[APMEDatabase initializeDatabaseResourcesWithContext:databasePath:] + 92
16  Runner.debug.dylib            	       0x1013715bc -[APMEDatabase initWithPath:] + 124
17  Runner.debug.dylib            	       0x101378e34 -[APMETaskManager startTaskManagerOnWorkerQueue] + 56
18  Runner.debug.dylib            	       0x101378dec __35-[APMETaskManager startTaskManager]_block_invoke + 28
19  Runner.debug.dylib            	       0x10137a100 __46-[APMETaskManager dispatchAsyncOnWorkerQueue:]_block_invoke + 36
20  libdispatch.dylib             	       0x1801c07a8 _dispatch_call_block_and_release + 24
21  libdispatch.dylib             	       0x1801db4b0 _dispatch_client_callout + 12
22  libdispatch.dylib             	       0x1801c9c28 _dispatch_lane_serial_drain + 984
23  libdispatch.dylib             	       0x1801ca6e8 _dispatch_lane_invoke + 396
24  libdispatch.dylib             	       0x1801d5534 _dispatch_root_queue_drain_deferred_wlh + 288
25  libdispatch.dylib             	       0x1801d4c74 _dispatch_workloop_worker_thread + 692
26  libsystem_pthread.dylib       	       0x101a32b8c _pthread_wqthread + 288
27  libsystem_pthread.dylib       	       0x101a3198c start_wqthread + 8

Thread 12:

Thread 13:

Thread 14:

Thread 15:

Thread 16:

Thread 17:

Thread 18:: io.flutter.1.raster
0   libsystem_kernel.dylib        	       0x1011acb70 mach_msg2_trap + 8
1   libsystem_kernel.dylib        	       0x1011bd90c mach_msg2_internal + 72
2   libsystem_kernel.dylib        	       0x1011b4c10 mach_msg_overwrite + 480
3   libsystem_kernel.dylib        	       0x1011acee4 mach_msg + 20
4   CoreFoundation                	       0x180455c04 __CFRunLoopServiceMachPort + 156
5   CoreFoundation                	       0x180454dbc __CFRunLoopRun + 1128
6   CoreFoundation                	       0x18044fcec _CFRunLoopRunSpecificWithOptions + 496
7   Flutter                       	       0x10452ee74 fml::MessageLoopDarwin::Run() + 92
8   Flutter                       	       0x10452793c fml::MessageLoopImpl::DoRun() + 44
9   Flutter                       	       0x10452d51c std::__fl::__function::__func<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0, std::__fl::allocator<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0>, void ()>::operator()() + 184
10  Flutter                       	       0x10452d1e0 fml::ThreadHandle::ThreadHandle(std::__fl::function<void ()>&&)::$_0::__invoke(void*) + 36
11  libsystem_pthread.dylib       	       0x101a365ac _pthread_start + 104
12  libsystem_pthread.dylib       	       0x101a31998 thread_start + 8

Thread 19:: io.flutter.1.io
0   libsystem_kernel.dylib        	       0x1011acb70 mach_msg2_trap + 8
1   libsystem_kernel.dylib        	       0x1011bd90c mach_msg2_internal + 72
2   libsystem_kernel.dylib        	       0x1011b4c10 mach_msg_overwrite + 480
3   libsystem_kernel.dylib        	       0x1011acee4 mach_msg + 20
4   CoreFoundation                	       0x180455c04 __CFRunLoopServiceMachPort + 156
5   CoreFoundation                	       0x180454dbc __CFRunLoopRun + 1128
6   CoreFoundation                	       0x18044fcec _CFRunLoopRunSpecificWithOptions + 496
7   Flutter                       	       0x10452ee74 fml::MessageLoopDarwin::Run() + 92
8   Flutter                       	       0x10452793c fml::MessageLoopImpl::DoRun() + 44
9   Flutter                       	       0x10452d51c std::__fl::__function::__func<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0, std::__fl::allocator<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0>, void ()>::operator()() + 184
10  Flutter                       	       0x10452d1e0 fml::ThreadHandle::ThreadHandle(std::__fl::function<void ()>&&)::$_0::__invoke(void*) + 36
11  libsystem_pthread.dylib       	       0x101a365ac _pthread_start + 104
12  libsystem_pthread.dylib       	       0x101a31998 thread_start + 8

Thread 20:: io.flutter.1.profiler
0   libsystem_kernel.dylib        	       0x1011acb70 mach_msg2_trap + 8
1   libsystem_kernel.dylib        	       0x1011bd90c mach_msg2_internal + 72
2   libsystem_kernel.dylib        	       0x1011b4c10 mach_msg_overwrite + 480
3   libsystem_kernel.dylib        	       0x1011acee4 mach_msg + 20
4   CoreFoundation                	       0x180455c04 __CFRunLoopServiceMachPort + 156
5   CoreFoundation                	       0x180454dbc __CFRunLoopRun + 1128
6   CoreFoundation                	       0x18044fcec _CFRunLoopRunSpecificWithOptions + 496
7   Flutter                       	       0x10452ee74 fml::MessageLoopDarwin::Run() + 92
8   Flutter                       	       0x10452793c fml::MessageLoopImpl::DoRun() + 44
9   Flutter                       	       0x10452d51c std::__fl::__function::__func<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0, std::__fl::allocator<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0>, void ()>::operator()() + 184
10  Flutter                       	       0x10452d1e0 fml::ThreadHandle::ThreadHandle(std::__fl::function<void ()>&&)::$_0::__invoke(void*) + 36
11  libsystem_pthread.dylib       	       0x101a365ac _pthread_start + 104
12  libsystem_pthread.dylib       	       0x101a31998 thread_start + 8

Thread 21:: io.worker.1
0   libsystem_kernel.dylib        	       0x1011b0020 __psynch_cvwait + 8
1   libsystem_pthread.dylib       	       0x101a36a74 _pthread_cond_wait + 976
2   Flutter                       	       0x1044ffdc4 std::__fl::condition_variable::wait(std::__fl::unique_lock<std::__fl::mutex>&) + 24
3   Flutter                       	       0x1045240e0 fml::ConcurrentMessageLoop::WorkerMain() + 140
4   Flutter                       	       0x104524788 void* std::__fl::__thread_proxy[abi:nn210000]<std::__fl::tuple<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>>(void*) + 192
5   libsystem_pthread.dylib       	       0x101a365ac _pthread_start + 104
6   libsystem_pthread.dylib       	       0x101a31998 thread_start + 8

Thread 22:: io.worker.2
0   libsystem_kernel.dylib        	       0x1011b0020 __psynch_cvwait + 8
1   libsystem_pthread.dylib       	       0x101a36a74 _pthread_cond_wait + 976
2   Flutter                       	       0x1044ffdc4 std::__fl::condition_variable::wait(std::__fl::unique_lock<std::__fl::mutex>&) + 24
3   Flutter                       	       0x1045240e0 fml::ConcurrentMessageLoop::WorkerMain() + 140
4   Flutter                       	       0x104524788 void* std::__fl::__thread_proxy[abi:nn210000]<std::__fl::tuple<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>>(void*) + 192
5   libsystem_pthread.dylib       	       0x101a365ac _pthread_start + 104
6   libsystem_pthread.dylib       	       0x101a31998 thread_start + 8

Thread 23:: io.worker.3
0   libsystem_kernel.dylib        	       0x1011b0020 __psynch_cvwait + 8
1   libsystem_pthread.dylib       	       0x101a36a74 _pthread_cond_wait + 976
2   Flutter                       	       0x1044ffdc4 std::__fl::condition_variable::wait(std::__fl::unique_lock<std::__fl::mutex>&) + 24
3   Flutter                       	       0x1045240e0 fml::ConcurrentMessageLoop::WorkerMain() + 140
4   Flutter                       	       0x104524788 void* std::__fl::__thread_proxy[abi:nn210000]<std::__fl::tuple<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>>(void*) + 192
5   libsystem_pthread.dylib       	       0x101a365ac _pthread_start + 104
6   libsystem_pthread.dylib       	       0x101a31998 thread_start + 8

Thread 24:: io.worker.4
0   libsystem_kernel.dylib        	       0x1011b0020 __psynch_cvwait + 8
1   libsystem_pthread.dylib       	       0x101a36a74 _pthread_cond_wait + 976
2   Flutter                       	       0x1044ffdc4 std::__fl::condition_variable::wait(std::__fl::unique_lock<std::__fl::mutex>&) + 24
3   Flutter                       	       0x1045240e0 fml::ConcurrentMessageLoop::WorkerMain() + 140
4   Flutter                       	       0x104524788 void* std::__fl::__thread_proxy[abi:nn210000]<std::__fl::tuple<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>>(void*) + 192
5   libsystem_pthread.dylib       	       0x101a365ac _pthread_start + 104
6   libsystem_pthread.dylib       	       0x101a31998 thread_start + 8

Thread 25:: dart:io EventHandler
0   libsystem_kernel.dylib        	       0x1011b265c kevent + 8
1   Flutter                       	       0x104996180 dart::bin::EventHandlerImplementation::EventHandlerEntry(unsigned long) + 304
2   Flutter                       	       0x1049b2258 dart::bin::ThreadStart(void*) + 92
3   libsystem_pthread.dylib       	       0x101a365ac _pthread_start + 104
4   libsystem_pthread.dylib       	       0x101a31998 thread_start + 8

Thread 26:: Dart Profiler ThreadInterrupter
0   libsystem_kernel.dylib        	       0x1011b0020 __psynch_cvwait + 8
1   libsystem_pthread.dylib       	       0x101a36a74 _pthread_cond_wait + 976
2   Flutter                       	       0x1049ffb3c dart::ConditionVariable::WaitMicros(dart::Mutex*, long long) + 128
3   Flutter                       	       0x104b67a90 dart::ThreadInterrupter::ThreadMain(unsigned long) + 336
4   Flutter                       	       0x104b19cc0 dart::ThreadStart(void*) + 208
5   libsystem_pthread.dylib       	       0x101a365ac _pthread_start + 104
6   libsystem_pthread.dylib       	       0x101a31998 thread_start + 8

Thread 27:: Dart Profiler SampleBlockProcessor
0   libsystem_kernel.dylib        	       0x1011b0020 __psynch_cvwait + 8
1   libsystem_pthread.dylib       	       0x101a36aa0 _pthread_cond_wait + 1020
2   Flutter                       	       0x1049ffb2c dart::ConditionVariable::WaitMicros(dart::Mutex*, long long) + 112
3   Flutter                       	       0x104b1ecc0 dart::SampleBlockProcessor::ThreadMain(unsigned long) + 220
4   Flutter                       	       0x104b19cc0 dart::ThreadStart(void*) + 208
5   libsystem_pthread.dylib       	       0x101a365ac _pthread_start + 104
6   libsystem_pthread.dylib       	       0x101a31998 thread_start + 8

Thread 28:: DartWorker
0   libsystem_kernel.dylib        	       0x1011b0020 __psynch_cvwait + 8
1   libsystem_pthread.dylib       	       0x101a36aa0 _pthread_cond_wait + 1020
2   Flutter                       	       0x1049ffb2c dart::ConditionVariable::WaitMicros(dart::Mutex*, long long) + 112
3   Flutter                       	       0x104b68830 dart::ThreadPool::WorkerLoop(dart::ThreadPool::Worker*) + 512
4   Flutter                       	       0x104b68990 dart::ThreadPool::Worker::Main(unsigned long) + 116
5   Flutter                       	       0x104b19cc0 dart::ThreadStart(void*) + 208
6   libsystem_pthread.dylib       	       0x101a365ac _pthread_start + 104
7   libsystem_pthread.dylib       	       0x101a31998 thread_start + 8

Thread 29:: DartWorker
0   libsystem_kernel.dylib        	       0x1011b0020 __psynch_cvwait + 8
1   libsystem_pthread.dylib       	       0x101a36aa0 _pthread_cond_wait + 1020
2   Flutter                       	       0x1049ffb2c dart::ConditionVariable::WaitMicros(dart::Mutex*, long long) + 112
3   Flutter                       	       0x104b68830 dart::ThreadPool::WorkerLoop(dart::ThreadPool::Worker*) + 512
4   Flutter                       	       0x104b68990 dart::ThreadPool::Worker::Main(unsigned long) + 116
5   Flutter                       	       0x104b19cc0 dart::ThreadStart(void*) + 208
6   libsystem_pthread.dylib       	       0x101a365ac _pthread_start + 104
7   libsystem_pthread.dylib       	       0x101a31998 thread_start + 8

Thread 30:: DartWorker
0   libsystem_kernel.dylib        	       0x1011b0020 __psynch_cvwait + 8
1   libsystem_pthread.dylib       	       0x101a36aa0 _pthread_cond_wait + 1020
2   Flutter                       	       0x1049ffb2c dart::ConditionVariable::WaitMicros(dart::Mutex*, long long) + 112
3   Flutter                       	       0x104a5fa8c dart::MutatorThreadPool::OnEnterIdleLocked(dart::MutexLocker*, dart::ThreadPool::Worker*) + 156
4   Flutter                       	       0x104b686ac dart::ThreadPool::WorkerLoop(dart::ThreadPool::Worker*) + 124
5   Flutter                       	       0x104b68990 dart::ThreadPool::Worker::Main(unsigned long) + 116
6   Flutter                       	       0x104b19cc0 dart::ThreadStart(void*) + 208
7   libsystem_pthread.dylib       	       0x101a365ac _pthread_start + 104
8   libsystem_pthread.dylib       	       0x101a31998 thread_start + 8

Thread 31:: DartWorker
0   libsystem_kernel.dylib        	       0x1011b0020 __psynch_cvwait + 8
1   libsystem_pthread.dylib       	       0x101a36aa0 _pthread_cond_wait + 1020
2   Flutter                       	       0x1049ffb2c dart::ConditionVariable::WaitMicros(dart::Mutex*, long long) + 112
3   Flutter                       	       0x104b68830 dart::ThreadPool::WorkerLoop(dart::ThreadPool::Worker*) + 512
4   Flutter                       	       0x104b68990 dart::ThreadPool::Worker::Main(unsigned long) + 116
5   Flutter                       	       0x104b19cc0 dart::ThreadStart(void*) + 208
6   libsystem_pthread.dylib       	       0x101a365ac _pthread_start + 104
7   libsystem_pthread.dylib       	       0x101a31998 thread_start + 8


Thread 0 crashed with ARM Thread State (64-bit):
    x0: 0x0000000000000000   x1: 0x0000000000000000   x2: 0x0000000000000000   x3: 0x0000000000000000
    x4: 0x0000000180306cab   x5: 0x000000016f1f3150   x6: 0x000000000000006e   x7: 0x0000000000000000
    x8: 0x0000000100cfde40   x9: 0x3af3b0f6ed86f35f  x10: 0x0000000000000002  x11: 0x0000010000000000
   x12: 0x00000000fffffffd  x13: 0x0000000000000000  x14: 0x0000000000000000  x15: 0x0000000000000000
   x16: 0x0000000000000148  x17: 0x0000000000000002  x18: 0x0000000000000000  x19: 0x0000000000000006
   x20: 0x0000000000000103  x21: 0x0000000100cfdf20  x22: 0x00000001f26c8000  x23: 0x00000001014f8dd8
   x24: 0x000060000174a8c0  x25: 0x0000600001749080  x26: 0x0000000000000000  x27: 0x0000000000000000
   x28: 0x0000000000000114   fp: 0x000000016f1f30c0   lr: 0x0000000101a362a8
    sp: 0x000000016f1f30a0   pc: 0x00000001011b485c cpsr: 0x40001000
   far: 0x0000000000000000  esr: 0x56000080 (Syscall)

Binary Images:
       0x100c50000 -        0x100ceffff dyld (*) <0975afba-c46b-364c-bd84-a75daa9e455a> /usr/lib/dyld
       0x100c08000 -        0x100c0bfff com.nebulainfinity.japanLifeNavi (0.1.0) <cae6df76-9aef-3c99-811b-6c78c9cbbbc3> /Users/USER/Library/Developer/CoreSimulator/Devices/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4/data/Containers/Bundle/Application/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190/Runner.app/Runner
       0x1012a0000 -        0x1014bbfff Runner.debug.dylib (*) <5c77f498-0fb1-3a2f-9722-2338da86d25e> /Users/USER/Library/Developer/CoreSimulator/Devices/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4/data/Containers/Bundle/Application/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190/Runner.app/Runner.debug.dylib
       0x100dbc000 -        0x100dcffff org.cocoapods.FBLPromises (2.4.0) <0bdad83c-f5d0-3081-8e47-cbc4aa53f733> /Users/USER/Library/Developer/CoreSimulator/Devices/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4/data/Containers/Bundle/Application/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190/Runner.app/Frameworks/FBLPromises.framework/FBLPromises
       0x100c38000 -        0x100c3bfff org.cocoapods.FirebaseAppCheckInterop (11.15.0) <6ff2ff85-5a78-35c1-81f4-936525d548f1> /Users/USER/Library/Developer/CoreSimulator/Devices/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4/data/Containers/Bundle/Application/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190/Runner.app/Frameworks/FirebaseAppCheckInterop.framework/FirebaseAppCheckInterop
       0x101678000 -        0x101807fff org.cocoapods.FirebaseAuth (11.15.0) <3b3459bb-ca28-3bb0-b985-d5f2e7cddce4> /Users/USER/Library/Developer/CoreSimulator/Devices/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4/data/Containers/Bundle/Application/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190/Runner.app/Frameworks/FirebaseAuth.framework/FirebaseAuth
       0x100d84000 -        0x100d87fff org.cocoapods.FirebaseAuthInterop (11.15.0) <3bd86be0-6cfb-3b38-b014-2d715e221fcb> /Users/USER/Library/Developer/CoreSimulator/Devices/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4/data/Containers/Bundle/Application/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190/Runner.app/Frameworks/FirebaseAuthInterop.framework/FirebaseAuthInterop
       0x100f14000 -        0x100f27fff org.cocoapods.FirebaseCore (11.15.0) <ddc6b862-cfaf-3e76-84f1-e5bafe7b96ad> /Users/USER/Library/Developer/CoreSimulator/Devices/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4/data/Containers/Bundle/Application/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190/Runner.app/Frameworks/FirebaseCore.framework/FirebaseCore
       0x100d98000 -        0x100d9bfff org.cocoapods.FirebaseCoreExtension (11.15.0) <7a1408e9-74b0-30c4-8909-39d839222d0e> /Users/USER/Library/Developer/CoreSimulator/Devices/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4/data/Containers/Bundle/Application/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190/Runner.app/Frameworks/FirebaseCoreExtension.framework/FirebaseCoreExtension
       0x100fc8000 -        0x100feffff org.cocoapods.FirebaseCoreInternal (11.15.0) <95a316a0-9826-3db0-adcf-3beed47ea605> /Users/USER/Library/Developer/CoreSimulator/Devices/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4/data/Containers/Bundle/Application/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190/Runner.app/Frameworks/FirebaseCoreInternal.framework/FirebaseCoreInternal
       0x101044000 -        0x10105ffff org.cocoapods.FirebaseInstallations (11.15.0) <5d1adfd9-1a13-328b-969f-ae0d00a0fd2f> /Users/USER/Library/Developer/CoreSimulator/Devices/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4/data/Containers/Bundle/Application/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190/Runner.app/Frameworks/FirebaseInstallations.framework/FirebaseInstallations
       0x10111c000 -        0x10116bfff org.cocoapods.GTMSessionFetcher (4.5.0) <ea6b0445-a438-3dfa-87ce-35956f96c5cc> /Users/USER/Library/Developer/CoreSimulator/Devices/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4/data/Containers/Bundle/Application/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190/Runner.app/Frameworks/GTMSessionFetcher.framework/GTMSessionFetcher
       0x101088000 -        0x1010abfff org.cocoapods.GoogleUtilities (8.1.0) <0a5b2568-a191-3233-81d9-08616d8d6aab> /Users/USER/Library/Developer/CoreSimulator/Devices/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4/data/Containers/Bundle/Application/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190/Runner.app/Frameworks/GoogleUtilities.framework/GoogleUtilities
       0x100df0000 -        0x100df3fff org.cocoapods.RecaptchaInterop (101.0.0) <4e710d37-be16-3ef2-ac15-93eeecaee554> /Users/USER/Library/Developer/CoreSimulator/Devices/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4/data/Containers/Bundle/Application/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190/Runner.app/Frameworks/RecaptchaInterop.framework/RecaptchaInterop
       0x100c20000 -        0x100c27fff org.cocoapods.nanopb (3.30910.0) <7c853d26-e373-3c39-95c2-28f6ae749a80> /Users/USER/Library/Developer/CoreSimulator/Devices/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4/data/Containers/Bundle/Application/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190/Runner.app/Frameworks/nanopb.framework/nanopb
       0x100f88000 -        0x100f9bfff org.cocoapods.shared-preferences-foundation (0.0.1) <3bcb7d9c-3bd5-326e-aa8c-b64aa4569ce4> /Users/USER/Library/Developer/CoreSimulator/Devices/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4/data/Containers/Bundle/Application/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190/Runner.app/Frameworks/shared_preferences_foundation.framework/shared_preferences_foundation
       0x101bfc000 -        0x101d53fff org.cocoapods.sqlite3 (3.51.1) <16fbf7c0-909a-381c-bf7e-35ce72174354> /Users/USER/Library/Developer/CoreSimulator/Devices/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4/data/Containers/Bundle/Application/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190/Runner.app/Frameworks/sqlite3.framework/sqlite3
       0x100edc000 -        0x100edffff org.cocoapods.sqlite3-flutter-libs (0.0.1) <00a57c8c-124d-3f54-a64d-4fa9a6e5d7fe> /Users/USER/Library/Developer/CoreSimulator/Devices/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4/data/Containers/Bundle/Application/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190/Runner.app/Frameworks/sqlite3_flutter_libs.framework/sqlite3_flutter_libs
       0x1010d4000 -        0x1010e7fff org.cocoapods.url-launcher-ios (0.0.1) <2468a95b-55f8-33f3-a4c4-f815496b911e> /Users/USER/Library/Developer/CoreSimulator/Devices/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4/data/Containers/Bundle/Application/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190/Runner.app/Frameworks/url_launcher_ios.framework/url_launcher_ios
       0x104490000 -        0x106317fff io.flutter.flutter (1.0) <4c4c4472-5555-3144-a129-5b766c61c004> /Users/USER/Library/Developer/CoreSimulator/Devices/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4/data/Containers/Bundle/Application/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190/Runner.app/Frameworks/Flutter.framework/Flutter
       0x100ef4000 -        0x100efbfff libsystem_platform.dylib (*) <de4033bb-4a6b-317a-bda6-b3a408656844> /usr/lib/system/libsystem_platform.dylib
       0x1011ac000 -        0x1011e7fff libsystem_kernel.dylib (*) <8f54f386-9b41-376a-9ba3-9423bbabb1b6> /usr/lib/system/libsystem_kernel.dylib
       0x101a30000 -        0x101a3ffff libsystem_pthread.dylib (*) <48ca2121-5ca2-3e04-bc91-a33151256e77> /usr/lib/system/libsystem_pthread.dylib
       0x101b3c000 -        0x101b47fff libobjc-trampolines.dylib (*) <997b234d-5c24-3e21-97d6-33b6853818c0> /Volumes/VOLUME/*/libobjc-trampolines.dylib
       0x180141000 -        0x1801be2c3 libsystem_c.dylib (*) <e0197e7b-9d61-356a-90b7-4be1270b82d5> /Volumes/VOLUME/*/libsystem_c.dylib
       0x1802f2000 -        0x18030a56f libc++abi.dylib (*) <0fc14bd2-2110-348c-8278-7a6fb63a7000> /Volumes/VOLUME/*/libc++abi.dylib
       0x180070000 -        0x1800ad297 libobjc.A.dylib (*) <880f8664-cd53-3912-bdd5-5e3159295f7d> /Volumes/VOLUME/*/libobjc.A.dylib
       0x1803c3000 -        0x1807df37f com.apple.CoreFoundation (6.9) <4f6d050d-95ee-3a95-969c-3a98b29df6ff> /Volumes/VOLUME/*/CoreFoundation.framework/CoreFoundation
       0x1801bf000 -        0x1802041bf libdispatch.dylib (*) <ec9ecf10-959d-3da1-a055-6de970159b9d> /Volumes/VOLUME/*/libdispatch.dylib
       0x192a64000 -        0x192a6bdbf com.apple.GraphicsServices (1.0) <4e5b0462-6170-3367-9475-4ff8b8dfe4e6> /Volumes/VOLUME/*/GraphicsServices.framework/GraphicsServices
       0x18519e000 -        0x1873c071f com.apple.UIKitCore (1.0) <196154ff-ba04-33cd-9277-98f9aa0b7499> /Volumes/VOLUME/*/UIKitCore.framework/UIKitCore
               0x0 - 0xffffffffffffffff ??? (*) <00000000-0000-0000-0000-000000000000> ???
       0x18085f000 -        0x1815d18df com.apple.Foundation (6.9) <c153116f-dd31-3fa9-89bb-04b47c1fa83d> /Volumes/VOLUME/*/Foundation.framework/Foundation
       0x18039e000 -        0x1803c2e63 libsystem_info.dylib (*) <96067617-d907-387c-9792-9c2a240c514d> /Volumes/VOLUME/*/libsystem_info.dylib

External Modification Summary:
  Calls made by other processes targeting this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by all processes on this machine:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0

VM Region Summary:
ReadOnly portion of Libraries: Total=2.0G resident=0K(0%) swapped_out_or_unallocated=2.0G(100%)
Writable regions: Total=767.6M written=2035K(0%) resident=2035K(0%) swapped_out=0K(0%) unallocated=765.6M(100%)

                                VIRTUAL   REGION 
REGION TYPE                        SIZE    COUNT (non-coalesced) 
===========                     =======  ======= 
Activity Tracing                   256K        1 
Foundation                          16K        1 
IOSurface                           16K        1 
Kernel Alloc Once                   32K        1 
MALLOC                           627.9M       87 
MALLOC guard page                  128K        8 
STACK GUARD                       56.5M       32 
Stack                             32.5M       32 
VM_ALLOCATE                      107.7M      272 
__DATA                            61.5M     1047 
__DATA_CONST                     131.4M     1074 
__DATA_DIRTY                       139K       13 
__FONT_DATA                        2352        1 
__LINKEDIT                       717.0M       25 
__OBJC_RO                         62.5M        1 
__OBJC_RW                         2771K        1 
__TEXT                             1.3G     1089 
__TPRO_CONST                       148K        2 
dyld private memory                2.2G       16 
mapped file                      103.6M       17 
page table in kernel              2035K        1 
shared memory                       16K        1 
===========                     =======  ======= 
TOTAL                              5.3G     3723 


-----------
Full Report
-----------

{"app_name":"Runner","timestamp":"2026-02-18 13:18:31.00 +0900","app_version":"0.1.0","slice_uuid":"cae6df76-9aef-3c99-811b-6c78c9cbbbc3","build_version":"1","platform":7,"bundleID":"com.nebulainfinity.japanLifeNavi","share_with_app_devs":0,"is_first_party":0,"bug_type":"309","os_version":"macOS 26.2 (25C56)","roots_installed":0,"name":"Runner","incident_id":"064E502E-917E-4BFC-8CE4-F58838C11F98"}
{
  "uptime" : 2200000,
  "procRole" : "Foreground",
  "version" : 2,
  "userID" : 501,
  "deployVersion" : 210,
  "modelCode" : "Mac15,6",
  "coalitionID" : 174800,
  "osVersion" : {
    "train" : "macOS 26.2",
    "build" : "25C56",
    "releaseType" : "User"
  },
  "captureTime" : "2026-02-18 13:18:27.8026 +0900",
  "codeSigningMonitor" : 2,
  "incident" : "064E502E-917E-4BFC-8CE4-F58838C11F98",
  "pid" : 51536,
  "translated" : false,
  "cpuType" : "ARM-64",
  "procLaunch" : "2026-02-18 13:18:26.7541 +0900",
  "procStartAbsTime" : 55078277623439,
  "procExitAbsTime" : 55078302743907,
  "procName" : "Runner",
  "procPath" : "\/Users\/USER\/Library\/Developer\/CoreSimulator\/Devices\/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4\/data\/Containers\/Bundle\/Application\/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190\/Runner.app\/Runner",
  "bundleInfo" : {"CFBundleShortVersionString":"0.1.0","CFBundleVersion":"1","CFBundleIdentifier":"com.nebulainfinity.japanLifeNavi"},
  "storeInfo" : {"deviceIdentifierForVendor":"DBD64415-9BBB-50D2-A362-A82C595CDB0F","thirdParty":true},
  "parentProc" : "launchd_sim",
  "parentPid" : 8302,
  "coalitionName" : "com.apple.CoreSimulator.SimDevice.49D52B25-B21A-47E4-B8BD-CACC37D5FCA4",
  "crashReporterKey" : "42E773A5-CE8E-1C2A-50CB-1171407FAD49",
  "appleIntelligenceStatus" : {"state":"available"},
  "developerMode" : 1,
  "responsiblePid" : 95854,
  "responsibleProc" : "SimulatorTrampoline",
  "codeSigningID" : "com.nebulainfinity.japanLifeNavi",
  "codeSigningTeamID" : "",
  "codeSigningFlags" : 570425857,
  "codeSigningValidationCategory" : 10,
  "codeSigningTrustLevel" : 4294967295,
  "codeSigningAuxiliaryInfo" : 0,
  "instructionByteStream" : {"beforePC":"4wAAVP17v6n9AwCRKeP\/l78DAJH9e8GowANf1sADX9YQKYDSARAA1A==","atPC":"4wAAVP17v6n9AwCRH+P\/l78DAJH9e8GowANf1sADX9ZwCoDSARAA1A=="},
  "bootSessionUUID" : "019C7D82-4B0B-4E97-BB47-F1477582FD92",
  "wakeTime" : 14597,
  "sleepWakeUUID" : "10A7EDF2-511B-4E65-997F-CCC746097EEB",
  "sip" : "enabled",
  "exception" : {"codes":"0x0000000000000000, 0x0000000000000000","rawCodes":[0,0],"type":"EXC_CRASH","signal":"SIGABRT"},
  "termination" : {"flags":0,"code":6,"namespace":"SIGNAL","indicator":"Abort trap: 6","byProc":"Runner","byPid":51536},
  "extMods" : {"caller":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"system":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"targeted":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"warnings":0},
  "lastExceptionBacktrace" : [{"imageOffset":1262020,"symbol":"__exceptionPreprocess","symbolLocation":160,"imageIndex":27},{"imageOffset":180372,"symbol":"objc_exception_throw","symbolLocation":72,"imageIndex":26},{"imageOffset":1261792,"symbol":"-[NSException initWithCoder:]","symbolLocation":0,"imageIndex":27},{"imageOffset":6692,"sourceLine":162,"sourceFile":"FIRInstallations.m","symbol":"+[FIRInstallations validateAPIKey:]","imageIndex":10,"symbolLocation":640},{"imageOffset":5984,"sourceLine":137,"sourceFile":"FIRInstallations.m","symbol":"+[FIRInstallations validateAppOptions:appName:]","imageIndex":10,"symbolLocation":668},{"imageOffset":4952,"sourceLine":91,"sourceFile":"FIRInstallations.m","symbol":"-[FIRInstallations initWithAppOptions:appName:installationsIDController:prefetchAuthToken:]","imageIndex":10,"symbolLocation":200},{"imageOffset":4640,"sourceLine":78,"sourceFile":"FIRInstallations.m","symbol":"-[FIRInstallations initWithApp:]","imageIndex":10,"symbolLocation":188},{"imageOffset":4356,"sourceLine":62,"sourceFile":"FIRInstallations.m","symbol":"__40+[FIRInstallations componentsToRegister]_block_invoke","imageIndex":10,"symbolLocation":132},{"imageOffset":27632,"sourceLine":161,"sourceFile":"FIRComponentContainer.m","symbol":"-[FIRComponentContainer instantiateInstanceForProtocol:withBlock:]","imageIndex":7,"symbolLocation":112},{"imageOffset":28380,"sourceLine":200,"sourceFile":"FIRComponentContainer.m","symbol":"-[FIRComponentContainer instanceForProtocol:]","imageIndex":7,"symbolLocation":320},{"imageOffset":30812,"sourceLine":26,"sourceFile":"FIRComponentType.m","symbol":"+[FIRComponentType instanceForProtocol:inContainer:]","imageIndex":7,"symbolLocation":92},{"imageOffset":7064,"sourceLine":192,"sourceFile":"FIRInstallations.m","symbol":"+[FIRInstallations installationsWithApp:]","imageIndex":10,"symbolLocation":120},{"imageOffset":6900,"sourceLine":188,"sourceFile":"FIRInstallations.m","symbol":"+[FIRInstallations installations]","imageIndex":10,"symbolLocation":124},{"imageOffset":28144,"symbol":"+[FIRAnalytics updateFirebaseInstallationID]","symbolLocation":24,"imageIndex":2},{"imageOffset":28044,"symbol":"+[FIRAnalytics startWithConfiguration:options:]","symbolLocation":356,"imageIndex":2},{"imageOffset":10892,"sourceLine":349,"sourceFile":"FIRApp.m","symbol":"-[FIRApp configureCore]","imageIndex":7,"symbolLocation":304},{"imageOffset":9764,"sourceLine":304,"sourceFile":"FIRApp.m","symbol":"+[FIRApp addAppToAppDictionary:]","imageIndex":7,"symbolLocation":124},{"imageOffset":6580,"sourceLine":187,"sourceFile":"FIRApp.m","symbol":"+[FIRApp configureWithName:options:]","imageIndex":7,"symbolLocation":1204},{"imageOffset":1700772,"symbol":"-[FLTFirebaseCorePlugin initializeAppAppName:initializeAppRequest:completion:]","symbolLocation":1740,"imageIndex":2},{"imageOffset":1718804,"symbol":"__SetUpFirebaseCoreHostApiWithSuffix_block_invoke","symbolLocation":312,"imageIndex":2},{"imageOffset":5539272,"symbol":"__48-[FlutterBasicMessageChannel setMessageHandler:]_block_invoke","symbolLocation":160,"imageIndex":19},{"imageOffset":435672,"symbol":"invocation function for block in flutter::PlatformMessageHandlerIos::HandlePlatformMessage(std::__fl::unique_ptr<flutter::PlatformMessage, std::__fl::default_delete<flutter::PlatformMessage>>)","symbolLocation":108,"imageIndex":19},{"imageOffset":6056,"symbol":"_dispatch_call_block_and_release","symbolLocation":24,"imageIndex":28},{"imageOffset":115888,"symbol":"_dispatch_client_callout","symbolLocation":12,"imageIndex":28},{"imageOffset":230560,"symbol":"<deduplicated_symbol>","symbolLocation":24,"imageIndex":28},{"imageOffset":70428,"symbol":"_dispatch_main_queue_drain","symbolLocation":1184,"imageIndex":28},{"imageOffset":69228,"symbol":"_dispatch_main_queue_callback_4CF","symbolLocation":40,"imageIndex":28},{"imageOffset":601816,"symbol":"__CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__","symbolLocation":12,"imageIndex":27},{"imageOffset":598192,"symbol":"__CFRunLoopRun","symbolLocation":1884,"imageIndex":27},{"imageOffset":576748,"symbol":"_CFRunLoopRunSpecificWithOptions","symbolLocation":496,"imageIndex":27},{"imageOffset":10684,"symbol":"GSEventRunModal","symbolLocation":116,"imageIndex":29},{"imageOffset":18523508,"symbol":"-[UIApplication _run]","symbolLocation":772,"imageIndex":30},{"imageOffset":18540444,"symbol":"UIApplicationMain","symbolLocation":124,"imageIndex":30},{"imageOffset":4068048,"imageIndex":30},{"imageOffset":10812,"sourceFile":"\/<compiler-generated>","symbol":"static UIApplicationDelegate.main()","symbolLocation":128,"imageIndex":2},{"imageOffset":10668,"sourceFile":"\/<compiler-generated>","symbol":"static AppDelegate.$main()","symbolLocation":44,"imageIndex":2},{"imageOffset":10936,"sourceFile":"\/<compiler-generated>","symbol":"__debug_main_executable_dylib_entry_point","symbolLocation":28,"imageIndex":2},{"imageOffset":4309783504,"imageIndex":31},{"imageOffset":36180,"symbol":"start","symbolLocation":7184,"imageIndex":0}],
  "faultingThread" : 0,
  "threads" : [{"triggered":true,"id":57253997,"threadState":{"x":[{"value":0},{"value":0},{"value":0},{"value":0},{"value":6445624491},{"value":6159282512},{"value":110},{"value":0},{"value":4308590144,"symbolLocation":0,"symbol":"_main_thread"},{"value":4247933448133997407},{"value":2},{"value":1099511627776},{"value":4294967293},{"value":0},{"value":0},{"value":0},{"value":328},{"value":2},{"value":0},{"value":6},{"value":259},{"value":4308590368,"symbolLocation":224,"symbol":"_main_thread"},{"value":8362164224,"symbolLocation":0,"symbol":"objc_debug_taggedpointer_classes"},{"value":4316958168,"symbolLocation":0,"symbol":"OBJC_CLASS_$_APMAnalytics"},{"value":105553140689088},{"value":105553140682880},{"value":0},{"value":0},{"value":276}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4322452136},"cpsr":{"value":1073745920},"fp":{"value":6159282368},"sp":{"value":6159282336},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4313532508,"matchesCrashFrame":1},"far":{"value":0}},"queue":"com.apple.main-thread","frames":[{"imageOffset":34908,"symbol":"__pthread_kill","symbolLocation":8,"imageIndex":21},{"imageOffset":25256,"symbol":"pthread_kill","symbolLocation":264,"imageIndex":22},{"imageOffset":477588,"symbol":"abort","symbolLocation":100,"imageIndex":24},{"imageOffset":70252,"symbol":"__abort_message","symbolLocation":128,"imageIndex":25},{"imageOffset":4516,"symbol":"demangling_terminate_handler()","symbolLocation":268,"imageIndex":25},{"imageOffset":29208,"symbol":"_objc_terminate()","symbolLocation":124,"imageIndex":26},{"imageOffset":67416,"symbol":"std::__terminate(void (*)())","symbolLocation":12,"imageIndex":25},{"imageOffset":79808,"symbol":"__cxxabiv1::failed_throw(__cxxabiv1::__cxa_exception*)","symbolLocation":32,"imageIndex":25},{"imageOffset":79776,"symbol":"__cxa_throw","symbolLocation":88,"imageIndex":25},{"imageOffset":180684,"symbol":"objc_exception_throw","symbolLocation":384,"imageIndex":26},{"imageOffset":1261792,"symbol":"+[NSException raise:format:]","symbolLocation":124,"imageIndex":27},{"imageOffset":6692,"sourceLine":162,"sourceFile":"FIRInstallations.m","symbol":"+[FIRInstallations validateAPIKey:]","imageIndex":10,"symbolLocation":640},{"imageOffset":5984,"sourceLine":137,"sourceFile":"FIRInstallations.m","symbol":"+[FIRInstallations validateAppOptions:appName:]","imageIndex":10,"symbolLocation":668},{"imageOffset":4952,"sourceLine":91,"sourceFile":"FIRInstallations.m","symbol":"-[FIRInstallations initWithAppOptions:appName:installationsIDController:prefetchAuthToken:]","imageIndex":10,"symbolLocation":200},{"imageOffset":4640,"sourceLine":78,"sourceFile":"FIRInstallations.m","symbol":"-[FIRInstallations initWithApp:]","imageIndex":10,"symbolLocation":188},{"imageOffset":4356,"sourceLine":62,"sourceFile":"FIRInstallations.m","symbol":"__40+[FIRInstallations componentsToRegister]_block_invoke","imageIndex":10,"symbolLocation":132},{"imageOffset":27632,"sourceLine":161,"sourceFile":"FIRComponentContainer.m","symbol":"-[FIRComponentContainer instantiateInstanceForProtocol:withBlock:]","imageIndex":7,"symbolLocation":112},{"imageOffset":28380,"sourceLine":200,"sourceFile":"FIRComponentContainer.m","symbol":"-[FIRComponentContainer instanceForProtocol:]","imageIndex":7,"symbolLocation":320},{"imageOffset":30812,"sourceLine":26,"sourceFile":"FIRComponentType.m","symbol":"+[FIRComponentType instanceForProtocol:inContainer:]","imageIndex":7,"symbolLocation":92},{"imageOffset":7064,"sourceLine":193,"sourceFile":"FIRInstallations.m","symbol":"+[FIRInstallations installationsWithApp:]","imageIndex":10,"symbolLocation":120},{"imageOffset":6900,"sourceLine":188,"sourceFile":"FIRInstallations.m","symbol":"+[FIRInstallations installations]","imageIndex":10,"symbolLocation":124},{"imageOffset":28144,"symbol":"+[FIRAnalytics updateFirebaseInstallationID]","symbolLocation":24,"imageIndex":2},{"imageOffset":28044,"symbol":"+[FIRAnalytics startWithConfiguration:options:]","symbolLocation":356,"imageIndex":2},{"imageOffset":10892,"sourceLine":349,"sourceFile":"FIRApp.m","symbol":"-[FIRApp configureCore]","imageIndex":7,"symbolLocation":304},{"imageOffset":9764,"sourceLine":304,"sourceFile":"FIRApp.m","symbol":"+[FIRApp addAppToAppDictionary:]","imageIndex":7,"symbolLocation":124},{"imageOffset":6580,"sourceLine":187,"sourceFile":"FIRApp.m","symbol":"+[FIRApp configureWithName:options:]","imageIndex":7,"symbolLocation":1204},{"imageOffset":1700772,"symbol":"-[FLTFirebaseCorePlugin initializeAppAppName:initializeAppRequest:completion:]","symbolLocation":1740,"imageIndex":2},{"imageOffset":1718804,"symbol":"__SetUpFirebaseCoreHostApiWithSuffix_block_invoke","symbolLocation":312,"imageIndex":2},{"imageOffset":5539272,"symbol":"__48-[FlutterBasicMessageChannel setMessageHandler:]_block_invoke","symbolLocation":160,"imageIndex":19},{"imageOffset":435672,"symbol":"invocation function for block in flutter::PlatformMessageHandlerIos::HandlePlatformMessage(std::__fl::unique_ptr<flutter::PlatformMessage, std::__fl::default_delete<flutter::PlatformMessage>>)","symbolLocation":108,"imageIndex":19},{"imageOffset":6056,"symbol":"_dispatch_call_block_and_release","symbolLocation":24,"imageIndex":28},{"imageOffset":115888,"symbol":"_dispatch_client_callout","symbolLocation":12,"imageIndex":28},{"imageOffset":230560,"symbol":"<deduplicated_symbol>","symbolLocation":24,"imageIndex":28},{"imageOffset":70428,"symbol":"_dispatch_main_queue_drain","symbolLocation":1184,"imageIndex":28},{"imageOffset":69228,"symbol":"_dispatch_main_queue_callback_4CF","symbolLocation":40,"imageIndex":28},{"imageOffset":601816,"symbol":"__CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__","symbolLocation":12,"imageIndex":27},{"imageOffset":598192,"symbol":"__CFRunLoopRun","symbolLocation":1884,"imageIndex":27},{"imageOffset":576748,"symbol":"_CFRunLoopRunSpecificWithOptions","symbolLocation":496,"imageIndex":27},{"imageOffset":10684,"symbol":"GSEventRunModal","symbolLocation":116,"imageIndex":29},{"imageOffset":18523508,"symbol":"-[UIApplication _run]","symbolLocation":772,"imageIndex":30},{"imageOffset":18540444,"symbol":"UIApplicationMain","symbolLocation":124,"imageIndex":30},{"imageOffset":4068048,"imageIndex":30},{"imageOffset":10812,"sourceFile":"\/<compiler-generated>","symbol":"static UIApplicationDelegate.main()","symbolLocation":128,"imageIndex":2},{"imageOffset":10668,"sourceFile":"\/<compiler-generated>","symbol":"static AppDelegate.$main()","symbolLocation":44,"imageIndex":2},{"imageOffset":10936,"sourceFile":"\/<compiler-generated>","symbol":"__debug_main_executable_dylib_entry_point","symbolLocation":28,"imageIndex":2},{"imageOffset":4309783504,"imageIndex":31},{"imageOffset":36180,"symbol":"start","symbolLocation":7184,"imageIndex":0}]},{"id":57254051,"frames":[],"threadState":{"x":[{"value":6159855616},{"value":4611},{"value":6159319040},{"value":0},{"value":409603},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6159855616},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4322433412},"far":{"value":0}}},{"id":57254052,"frames":[],"threadState":{"x":[{"value":6160429056},{"value":6915},{"value":6159892480},{"value":0},{"value":409603},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6160429056},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4322433412},"far":{"value":0}}},{"id":57254053,"frames":[],"threadState":{"x":[{"value":6161002496},{"value":6403},{"value":6160465920},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6161002496},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4322433412},"far":{"value":0}}},{"id":57254054,"frames":[],"threadState":{"x":[{"value":6161575936},{"value":10499},{"value":6161039360},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6161575936},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4322433412},"far":{"value":0}}},{"id":57254055,"name":"com.apple.uikit.eventfetch-thread","threadState":{"x":[{"value":268451845},{"value":21592279046},{"value":8589934592},{"value":50590419779584},{"value":2162692},{"value":50590419779584},{"value":2},{"value":4294967295},{"value":0},{"value":17179869184},{"value":0},{"value":2},{"value":0},{"value":0},{"value":11779},{"value":3072},{"value":18446744073709551569},{"value":2214801403},{"value":0},{"value":4294967295},{"value":2},{"value":50590419779584},{"value":2162692},{"value":50590419779584},{"value":6162144648},{"value":8589934592},{"value":21592279046},{"value":18446744073709550527},{"value":4412409862}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4313569548},"cpsr":{"value":4096},"fp":{"value":6162144496},"sp":{"value":6162144416},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4313500528},"far":{"value":0}},"frames":[{"imageOffset":2928,"symbol":"mach_msg2_trap","symbolLocation":8,"imageIndex":21},{"imageOffset":71948,"symbol":"mach_msg2_internal","symbolLocation":72,"imageIndex":21},{"imageOffset":35856,"symbol":"mach_msg_overwrite","symbolLocation":480,"imageIndex":21},{"imageOffset":3812,"symbol":"mach_msg","symbolLocation":20,"imageIndex":21},{"imageOffset":601092,"symbol":"__CFRunLoopServiceMachPort","symbolLocation":156,"imageIndex":27},{"imageOffset":597436,"symbol":"__CFRunLoopRun","symbolLocation":1128,"imageIndex":27},{"imageOffset":576748,"symbol":"_CFRunLoopRunSpecificWithOptions","symbolLocation":496,"imageIndex":27},{"imageOffset":9096776,"symbol":"-[NSRunLoop(NSRunLoop) runMode:beforeDate:]","symbolLocation":208,"imageIndex":32},{"imageOffset":9097320,"symbol":"-[NSRunLoop(NSRunLoop) runUntilDate:]","symbolLocation":60,"imageIndex":32},{"imageOffset":15735888,"symbol":"-[UIEventFetcher threadMain]","symbolLocation":392,"imageIndex":30},{"imageOffset":9256212,"symbol":"__NSThread__start__","symbolLocation":716,"imageIndex":32},{"imageOffset":26028,"symbol":"_pthread_start","symbolLocation":104,"imageIndex":22},{"imageOffset":6552,"symbol":"thread_start","symbolLocation":8,"imageIndex":22}]},{"id":57254056,"threadState":{"x":[{"value":17},{"value":0},{"value":0},{"value":2},{"value":2},{"value":6457850072,"symbolLocation":0,"symbol":"specialized thunk for @callee_guaranteed (@unowned UInt32, @unowned UnsafeMutablePointer<group>?, @unowned UnsafeMutablePointer<Int8>?, @unowned Int, @unowned UnsafeMutablePointer<UnsafeMutablePointer<group>?>?) -> (@unowned Int32)"},{"value":0},{"value":20},{"value":438},{"value":8},{"value":0},{"value":2},{"value":0},{"value":0},{"value":907},{"value":4354189312},{"value":398},{"value":2},{"value":0},{"value":8362219064,"symbolLocation":760,"symbol":"usual"},{"value":0},{"value":6446382879},{"value":8362334984,"symbolLocation":0,"symbol":"si_module_static_file.si"},{"value":20},{"value":8362336256,"symbolLocation":44,"symbol":"_res"},{"value":4327580624},{"value":0},{"value":8362481608,"symbolLocation":0,"symbol":"demangling cache variable for type metadata for (NSFileAttributeKey, Any)"},{"value":6461726384,"symbolLocation":0,"symbol":"mangled name ref for type metadata for (NSFileAttributeKey, Any)"}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4313579232},"cpsr":{"value":1073745920},"fp":{"value":6162716736},"sp":{"value":6162715616},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4313503464},"far":{"value":0}},"queue":"com.google.fira.worker","frames":[{"imageOffset":5864,"symbol":"__open_nocancel","symbolLocation":8,"imageIndex":21},{"imageOffset":81632,"symbol":"open$NOCANCEL","symbolLocation":72,"imageIndex":21},{"imageOffset":237732,"symbol":"fopen","symbolLocation":128,"imageIndex":24},{"imageOffset":15864,"symbol":"_fsi_get_group","symbolLocation":88,"imageIndex":33},{"imageOffset":53560,"symbol":"search_group_bygid","symbolLocation":72,"imageIndex":33},{"imageOffset":39656,"symbol":"getgrgid_r","symbolLocation":100,"imageIndex":33},{"imageOffset":6623636,"symbol":"specialized closure #1 in static Platform.withUserGroupBuffer<A, B, C>(_:_:sizeProperty:operation:block:)","symbolLocation":96,"imageIndex":32},{"imageOffset":6624108,"symbol":"specialized static Platform.name(forGID:)","symbolLocation":336,"imageIndex":32},{"imageOffset":3955000,"symbol":"closure #1 in _FileManagerImpl.attributesOfItem(atPath:)","symbolLocation":3784,"imageIndex":32},{"imageOffset":3904176,"symbol":"partial apply for closure #1 in _FileManagerImpl.attributesOfItem(atPath:)","symbolLocation":20,"imageIndex":32},{"imageOffset":6157564,"symbol":"specialized String.withFileSystemRepresentation<A>(_:)","symbolLocation":184,"imageIndex":32},{"imageOffset":3879968,"symbol":"specialized NSFileManager.withFileSystemRepresentation<A>(for:_:)","symbolLocation":208,"imageIndex":32},{"imageOffset":3884296,"symbol":"@objc _NSFileManagerBridge.attributesOfItem(atPath:)","symbolLocation":140,"imageIndex":32},{"imageOffset":1413920,"symbol":"-[APMSqliteStore openAndValidateDatabase:]","symbolLocation":100,"imageIndex":2},{"imageOffset":1399192,"symbol":"-[APMSqliteStore initWithDatabasePath:error:]","symbolLocation":184,"imageIndex":2},{"imageOffset":839976,"symbol":"-[APMDatabase initializeDatabaseResourcesWithContext:databasePath:error:]","symbolLocation":88,"imageIndex":2},{"imageOffset":803080,"symbol":"-[APMDatabase initWithDatabaseName:persistedConfig:error:]","symbolLocation":172,"imageIndex":2},{"imageOffset":973484,"symbol":"__47-[APMMeasurement startMeasurementOnWorkerQueue]_block_invoke","symbolLocation":452,"imageIndex":2},{"imageOffset":972832,"symbol":"-[APMMeasurement startMeasurementOnWorkerQueue]","symbolLocation":140,"imageIndex":2},{"imageOffset":971180,"symbol":"-[APMMeasurement setEnabledOnWorkerQueue:]","symbolLocation":168,"imageIndex":2},{"imageOffset":970996,"symbol":"__29-[APMMeasurement setEnabled:]_block_invoke","symbolLocation":36,"imageIndex":2},{"imageOffset":1375732,"symbol":"__51-[APMScheduler scheduleOnWorkerQueueBlockID:block:]_block_invoke","symbolLocation":44,"imageIndex":2},{"imageOffset":6056,"symbol":"_dispatch_call_block_and_release","symbolLocation":24,"imageIndex":28},{"imageOffset":115888,"symbol":"_dispatch_client_callout","symbolLocation":12,"imageIndex":28},{"imageOffset":44072,"symbol":"_dispatch_lane_serial_drain","symbolLocation":984,"imageIndex":28},{"imageOffset":46824,"symbol":"_dispatch_lane_invoke","symbolLocation":396,"imageIndex":28},{"imageOffset":91444,"symbol":"_dispatch_root_queue_drain_deferred_wlh","symbolLocation":288,"imageIndex":28},{"imageOffset":89204,"symbol":"_dispatch_workloop_worker_thread","symbolLocation":692,"imageIndex":28},{"imageOffset":11148,"symbol":"_pthread_wqthread","symbolLocation":288,"imageIndex":22},{"imageOffset":6540,"symbol":"start_wqthread","symbolLocation":8,"imageIndex":22}]},{"id":57254057,"frames":[],"threadState":{"x":[{"value":6163296256},{"value":13315},{"value":6162759680},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6163296256},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4322433412},"far":{"value":0}}},{"id":57254061,"frames":[],"threadState":{"x":[{"value":6163869696},{"value":19459},{"value":6163333120},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6163869696},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4322433412},"far":{"value":0}}},{"id":57254062,"frames":[],"threadState":{"x":[{"value":6164443136},{"value":17667},{"value":6163906560},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6164443136},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4322433412},"far":{"value":0}}},{"id":57254063,"frames":[],"threadState":{"x":[{"value":6165016576},{"value":17923},{"value":6164480000},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6165016576},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4322433412},"far":{"value":0}}},{"id":57254064,"threadState":{"x":[{"value":19},{"value":0},{"value":0},{"value":2},{"value":2},{"value":6457850072,"symbolLocation":0,"symbol":"specialized thunk for @callee_guaranteed (@unowned UInt32, @unowned UnsafeMutablePointer<group>?, @unowned UnsafeMutablePointer<Int8>?, @unowned Int, @unowned UnsafeMutablePointer<UnsafeMutablePointer<group>?>?) -> (@unowned Int32)"},{"value":0},{"value":20},{"value":438},{"value":8},{"value":0},{"value":2},{"value":0},{"value":0},{"value":1315},{"value":0},{"value":398},{"value":2},{"value":0},{"value":8362218304,"symbolLocation":0,"symbol":"usual"},{"value":0},{"value":6446382879},{"value":8362334984,"symbolLocation":0,"symbol":"si_module_static_file.si"},{"value":20},{"value":8362336256,"symbolLocation":44,"symbol":"_res"},{"value":4333820224},{"value":0},{"value":8362481608,"symbolLocation":0,"symbol":"demangling cache variable for type metadata for (NSFileAttributeKey, Any)"},{"value":6461726384,"symbolLocation":0,"symbol":"mangled name ref for type metadata for (NSFileAttributeKey, Any)"}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4313579232},"cpsr":{"value":1073745920},"fp":{"value":6165584224},"sp":{"value":6165583104},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4313503464},"far":{"value":0}},"queue":"APMExperimentWorkerQueue","frames":[{"imageOffset":5864,"symbol":"__open_nocancel","symbolLocation":8,"imageIndex":21},{"imageOffset":81632,"symbol":"open$NOCANCEL","symbolLocation":72,"imageIndex":21},{"imageOffset":237732,"symbol":"fopen","symbolLocation":128,"imageIndex":24},{"imageOffset":15864,"symbol":"_fsi_get_group","symbolLocation":88,"imageIndex":33},{"imageOffset":53560,"symbol":"search_group_bygid","symbolLocation":72,"imageIndex":33},{"imageOffset":39656,"symbol":"getgrgid_r","symbolLocation":100,"imageIndex":33},{"imageOffset":6623636,"symbol":"specialized closure #1 in static Platform.withUserGroupBuffer<A, B, C>(_:_:sizeProperty:operation:block:)","symbolLocation":96,"imageIndex":32},{"imageOffset":6624108,"symbol":"specialized static Platform.name(forGID:)","symbolLocation":336,"imageIndex":32},{"imageOffset":3955000,"symbol":"closure #1 in _FileManagerImpl.attributesOfItem(atPath:)","symbolLocation":3784,"imageIndex":32},{"imageOffset":3904176,"symbol":"partial apply for closure #1 in _FileManagerImpl.attributesOfItem(atPath:)","symbolLocation":20,"imageIndex":32},{"imageOffset":6157564,"symbol":"specialized String.withFileSystemRepresentation<A>(_:)","symbolLocation":184,"imageIndex":32},{"imageOffset":3879968,"symbol":"specialized NSFileManager.withFileSystemRepresentation<A>(for:_:)","symbolLocation":208,"imageIndex":32},{"imageOffset":3884296,"symbol":"@objc _NSFileManagerBridge.attributesOfItem(atPath:)","symbolLocation":140,"imageIndex":32},{"imageOffset":1413920,"symbol":"-[APMSqliteStore openAndValidateDatabase:]","symbolLocation":100,"imageIndex":2},{"imageOffset":1399192,"symbol":"-[APMSqliteStore initWithDatabasePath:error:]","symbolLocation":184,"imageIndex":2},{"imageOffset":857748,"symbol":"-[APMEDatabase initializeDatabaseResourcesWithContext:databasePath:]","symbolLocation":92,"imageIndex":2},{"imageOffset":857532,"symbol":"-[APMEDatabase initWithPath:]","symbolLocation":124,"imageIndex":2},{"imageOffset":888372,"symbol":"-[APMETaskManager startTaskManagerOnWorkerQueue]","symbolLocation":56,"imageIndex":2},{"imageOffset":888300,"symbol":"__35-[APMETaskManager startTaskManager]_block_invoke","symbolLocation":28,"imageIndex":2},{"imageOffset":893184,"symbol":"__46-[APMETaskManager dispatchAsyncOnWorkerQueue:]_block_invoke","symbolLocation":36,"imageIndex":2},{"imageOffset":6056,"symbol":"_dispatch_call_block_and_release","symbolLocation":24,"imageIndex":28},{"imageOffset":115888,"symbol":"_dispatch_client_callout","symbolLocation":12,"imageIndex":28},{"imageOffset":44072,"symbol":"_dispatch_lane_serial_drain","symbolLocation":984,"imageIndex":28},{"imageOffset":46824,"symbol":"_dispatch_lane_invoke","symbolLocation":396,"imageIndex":28},{"imageOffset":91444,"symbol":"_dispatch_root_queue_drain_deferred_wlh","symbolLocation":288,"imageIndex":28},{"imageOffset":89204,"symbol":"_dispatch_workloop_worker_thread","symbolLocation":692,"imageIndex":28},{"imageOffset":11148,"symbol":"_pthread_wqthread","symbolLocation":288,"imageIndex":22},{"imageOffset":6540,"symbol":"start_wqthread","symbolLocation":8,"imageIndex":22}]},{"id":57254065,"frames":[],"threadState":{"x":[{"value":6166163456},{"value":18691},{"value":6165626880},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6166163456},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4322433412},"far":{"value":0}}},{"id":57254066,"frames":[],"threadState":{"x":[{"value":6166736896},{"value":18435},{"value":6166200320},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6166736896},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4322433412},"far":{"value":0}}},{"id":57254067,"frames":[],"threadState":{"x":[{"value":6167310336},{"value":21763},{"value":6166773760},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6167310336},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4322433412},"far":{"value":0}}},{"id":57254068,"frames":[],"threadState":{"x":[{"value":6167883776},{"value":32515},{"value":6167347200},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6167883776},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4322433412},"far":{"value":0}}},{"id":57254069,"frames":[],"threadState":{"x":[{"value":6168457216},{"value":32259},{"value":6167920640},{"value":0},{"value":409603},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6168457216},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4322433412},"far":{"value":0}}},{"id":57254070,"frames":[],"threadState":{"x":[{"value":6169030656},{"value":0},{"value":6168494080},{"value":0},{"value":278532},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6169030656},"esr":{"value":0},"pc":{"value":4322433412},"far":{"value":0}}},{"id":57254072,"name":"io.flutter.1.raster","threadState":{"x":[{"value":268451845},{"value":21592279046},{"value":8589934592},{"value":120959163957248},{"value":0},{"value":120959163957248},{"value":2},{"value":4294967295},{"value":0},{"value":17179869184},{"value":0},{"value":2},{"value":0},{"value":0},{"value":28163},{"value":3072},{"value":18446744073709551569},{"value":3298534884098},{"value":0},{"value":4294967295},{"value":2},{"value":120959163957248},{"value":0},{"value":120959163957248},{"value":6171172872},{"value":8589934592},{"value":21592279046},{"value":18446744073709550527},{"value":4412409862}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4313569548},"cpsr":{"value":4096},"fp":{"value":6171172720},"sp":{"value":6171172640},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4313500528},"far":{"value":0}},"frames":[{"imageOffset":2928,"symbol":"mach_msg2_trap","symbolLocation":8,"imageIndex":21},{"imageOffset":71948,"symbol":"mach_msg2_internal","symbolLocation":72,"imageIndex":21},{"imageOffset":35856,"symbol":"mach_msg_overwrite","symbolLocation":480,"imageIndex":21},{"imageOffset":3812,"symbol":"mach_msg","symbolLocation":20,"imageIndex":21},{"imageOffset":601092,"symbol":"__CFRunLoopServiceMachPort","symbolLocation":156,"imageIndex":27},{"imageOffset":597436,"symbol":"__CFRunLoopRun","symbolLocation":1128,"imageIndex":27},{"imageOffset":576748,"symbol":"_CFRunLoopRunSpecificWithOptions","symbolLocation":496,"imageIndex":27},{"imageOffset":650868,"symbol":"fml::MessageLoopDarwin::Run()","symbolLocation":92,"imageIndex":19},{"imageOffset":620860,"symbol":"fml::MessageLoopImpl::DoRun()","symbolLocation":44,"imageIndex":19},{"imageOffset":644380,"symbol":"std::__fl::__function::__func<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0, std::__fl::allocator<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0>, void ()>::operator()()","symbolLocation":184,"imageIndex":19},{"imageOffset":643552,"symbol":"fml::ThreadHandle::ThreadHandle(std::__fl::function<void ()>&&)::$_0::__invoke(void*)","symbolLocation":36,"imageIndex":19},{"imageOffset":26028,"symbol":"_pthread_start","symbolLocation":104,"imageIndex":22},{"imageOffset":6552,"symbol":"thread_start","symbolLocation":8,"imageIndex":22}]},{"id":57254073,"name":"io.flutter.1.io","threadState":{"x":[{"value":268451845},{"value":21592279046},{"value":8589934592},{"value":108864536051712},{"value":0},{"value":108864536051712},{"value":2},{"value":4294967295},{"value":0},{"value":17179869184},{"value":0},{"value":2},{"value":0},{"value":0},{"value":25347},{"value":3072},{"value":18446744073709551569},{"value":2},{"value":0},{"value":4294967295},{"value":2},{"value":108864536051712},{"value":0},{"value":108864536051712},{"value":6173319176},{"value":8589934592},{"value":21592279046},{"value":18446744073709550527},{"value":4412409862}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4313569548},"cpsr":{"value":4096},"fp":{"value":6173319024},"sp":{"value":6173318944},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4313500528},"far":{"value":0}},"frames":[{"imageOffset":2928,"symbol":"mach_msg2_trap","symbolLocation":8,"imageIndex":21},{"imageOffset":71948,"symbol":"mach_msg2_internal","symbolLocation":72,"imageIndex":21},{"imageOffset":35856,"symbol":"mach_msg_overwrite","symbolLocation":480,"imageIndex":21},{"imageOffset":3812,"symbol":"mach_msg","symbolLocation":20,"imageIndex":21},{"imageOffset":601092,"symbol":"__CFRunLoopServiceMachPort","symbolLocation":156,"imageIndex":27},{"imageOffset":597436,"symbol":"__CFRunLoopRun","symbolLocation":1128,"imageIndex":27},{"imageOffset":576748,"symbol":"_CFRunLoopRunSpecificWithOptions","symbolLocation":496,"imageIndex":27},{"imageOffset":650868,"symbol":"fml::MessageLoopDarwin::Run()","symbolLocation":92,"imageIndex":19},{"imageOffset":620860,"symbol":"fml::MessageLoopImpl::DoRun()","symbolLocation":44,"imageIndex":19},{"imageOffset":644380,"symbol":"std::__fl::__function::__func<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0, std::__fl::allocator<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0>, void ()>::operator()()","symbolLocation":184,"imageIndex":19},{"imageOffset":643552,"symbol":"fml::ThreadHandle::ThreadHandle(std::__fl::function<void ()>&&)::$_0::__invoke(void*)","symbolLocation":36,"imageIndex":19},{"imageOffset":26028,"symbol":"_pthread_start","symbolLocation":104,"imageIndex":22},{"imageOffset":6552,"symbol":"thread_start","symbolLocation":8,"imageIndex":22}]},{"id":57254074,"name":"io.flutter.1.profiler","threadState":{"x":[{"value":268451845},{"value":21592279046},{"value":8589934592},{"value":142949396512768},{"value":0},{"value":142949396512768},{"value":2},{"value":4294967295},{"value":0},{"value":17179869184},{"value":0},{"value":2},{"value":0},{"value":0},{"value":33283},{"value":3072},{"value":18446744073709551569},{"value":2},{"value":0},{"value":4294967295},{"value":2},{"value":142949396512768},{"value":0},{"value":142949396512768},{"value":6175465480},{"value":8589934592},{"value":21592279046},{"value":18446744073709550527},{"value":4412409862}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4313569548},"cpsr":{"value":4096},"fp":{"value":6175465328},"sp":{"value":6175465248},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4313500528},"far":{"value":0}},"frames":[{"imageOffset":2928,"symbol":"mach_msg2_trap","symbolLocation":8,"imageIndex":21},{"imageOffset":71948,"symbol":"mach_msg2_internal","symbolLocation":72,"imageIndex":21},{"imageOffset":35856,"symbol":"mach_msg_overwrite","symbolLocation":480,"imageIndex":21},{"imageOffset":3812,"symbol":"mach_msg","symbolLocation":20,"imageIndex":21},{"imageOffset":601092,"symbol":"__CFRunLoopServiceMachPort","symbolLocation":156,"imageIndex":27},{"imageOffset":597436,"symbol":"__CFRunLoopRun","symbolLocation":1128,"imageIndex":27},{"imageOffset":576748,"symbol":"_CFRunLoopRunSpecificWithOptions","symbolLocation":496,"imageIndex":27},{"imageOffset":650868,"symbol":"fml::MessageLoopDarwin::Run()","symbolLocation":92,"imageIndex":19},{"imageOffset":620860,"symbol":"fml::MessageLoopImpl::DoRun()","symbolLocation":44,"imageIndex":19},{"imageOffset":644380,"symbol":"std::__fl::__function::__func<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0, std::__fl::allocator<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0>, void ()>::operator()()","symbolLocation":184,"imageIndex":19},{"imageOffset":643552,"symbol":"fml::ThreadHandle::ThreadHandle(std::__fl::function<void ()>&&)::$_0::__invoke(void*)","symbolLocation":36,"imageIndex":19},{"imageOffset":26028,"symbol":"_pthread_start","symbolLocation":104,"imageIndex":22},{"imageOffset":6552,"symbol":"thread_start","symbolLocation":8,"imageIndex":22}]},{"id":57254075,"name":"io.worker.1","threadState":{"x":[{"value":4},{"value":0},{"value":1024},{"value":0},{"value":0},{"value":160},{"value":0},{"value":0},{"value":6176042472},{"value":0},{"value":256},{"value":1099511628034},{"value":1099511628034},{"value":256},{"value":0},{"value":1099511628032},{"value":305},{"value":187},{"value":0},{"value":4327534024},{"value":4327534088},{"value":6176043232},{"value":0},{"value":0},{"value":1024},{"value":1025},{"value":1280},{"value":6176042712},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4322454132},"cpsr":{"value":1610616832},"fp":{"value":6176042592},"sp":{"value":6176042448},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4313514016},"far":{"value":0}},"frames":[{"imageOffset":16416,"symbol":"__psynch_cvwait","symbolLocation":8,"imageIndex":21},{"imageOffset":27252,"symbol":"_pthread_cond_wait","symbolLocation":976,"imageIndex":22},{"imageOffset":458180,"symbol":"std::__fl::condition_variable::wait(std::__fl::unique_lock<std::__fl::mutex>&)","symbolLocation":24,"imageIndex":19},{"imageOffset":606432,"symbol":"fml::ConcurrentMessageLoop::WorkerMain()","symbolLocation":140,"imageIndex":19},{"imageOffset":608136,"symbol":"void* std::__fl::__thread_proxy[abi:nn210000]<std::__fl::tuple<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>>(void*)","symbolLocation":192,"imageIndex":19},{"imageOffset":26028,"symbol":"_pthread_start","symbolLocation":104,"imageIndex":22},{"imageOffset":6552,"symbol":"thread_start","symbolLocation":8,"imageIndex":22}]},{"id":57254076,"name":"io.worker.2","threadState":{"x":[{"value":4},{"value":0},{"value":1024},{"value":0},{"value":0},{"value":160},{"value":0},{"value":0},{"value":6176615912},{"value":0},{"value":256},{"value":1099511628034},{"value":1099511628034},{"value":256},{"value":0},{"value":1099511628032},{"value":305},{"value":188},{"value":0},{"value":4327534024},{"value":4327534088},{"value":6176616672},{"value":0},{"value":0},{"value":1024},{"value":1024},{"value":1536},{"value":6176616152},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4322454132},"cpsr":{"value":1610616832},"fp":{"value":6176616032},"sp":{"value":6176615888},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4313514016},"far":{"value":0}},"frames":[{"imageOffset":16416,"symbol":"__psynch_cvwait","symbolLocation":8,"imageIndex":21},{"imageOffset":27252,"symbol":"_pthread_cond_wait","symbolLocation":976,"imageIndex":22},{"imageOffset":458180,"symbol":"std::__fl::condition_variable::wait(std::__fl::unique_lock<std::__fl::mutex>&)","symbolLocation":24,"imageIndex":19},{"imageOffset":606432,"symbol":"fml::ConcurrentMessageLoop::WorkerMain()","symbolLocation":140,"imageIndex":19},{"imageOffset":608136,"symbol":"void* std::__fl::__thread_proxy[abi:nn210000]<std::__fl::tuple<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>>(void*)","symbolLocation":192,"imageIndex":19},{"imageOffset":26028,"symbol":"_pthread_start","symbolLocation":104,"imageIndex":22},{"imageOffset":6552,"symbol":"thread_start","symbolLocation":8,"imageIndex":22}]},{"id":57254077,"name":"io.worker.3","threadState":{"x":[{"value":4},{"value":0},{"value":1024},{"value":0},{"value":0},{"value":160},{"value":0},{"value":0},{"value":6177189352},{"value":0},{"value":256},{"value":1099511628034},{"value":1099511628034},{"value":256},{"value":0},{"value":1099511628032},{"value":305},{"value":189},{"value":0},{"value":4327534024},{"value":4327534088},{"value":6177190112},{"value":0},{"value":0},{"value":1024},{"value":1024},{"value":2048},{"value":6177189592},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4322454132},"cpsr":{"value":1610616832},"fp":{"value":6177189472},"sp":{"value":6177189328},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4313514016},"far":{"value":0}},"frames":[{"imageOffset":16416,"symbol":"__psynch_cvwait","symbolLocation":8,"imageIndex":21},{"imageOffset":27252,"symbol":"_pthread_cond_wait","symbolLocation":976,"imageIndex":22},{"imageOffset":458180,"symbol":"std::__fl::condition_variable::wait(std::__fl::unique_lock<std::__fl::mutex>&)","symbolLocation":24,"imageIndex":19},{"imageOffset":606432,"symbol":"fml::ConcurrentMessageLoop::WorkerMain()","symbolLocation":140,"imageIndex":19},{"imageOffset":608136,"symbol":"void* std::__fl::__thread_proxy[abi:nn210000]<std::__fl::tuple<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>>(void*)","symbolLocation":192,"imageIndex":19},{"imageOffset":26028,"symbol":"_pthread_start","symbolLocation":104,"imageIndex":22},{"imageOffset":6552,"symbol":"thread_start","symbolLocation":8,"imageIndex":22}]},{"id":57254078,"name":"io.worker.4","threadState":{"x":[{"value":260},{"value":0},{"value":1024},{"value":0},{"value":0},{"value":160},{"value":0},{"value":0},{"value":6177762792},{"value":0},{"value":256},{"value":1099511628034},{"value":1099511628034},{"value":256},{"value":0},{"value":1099511628032},{"value":305},{"value":190},{"value":0},{"value":4327534024},{"value":4327534088},{"value":6177763552},{"value":0},{"value":0},{"value":1024},{"value":1024},{"value":1792},{"value":6177763032},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4322454132},"cpsr":{"value":1610616832},"fp":{"value":6177762912},"sp":{"value":6177762768},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4313514016},"far":{"value":0}},"frames":[{"imageOffset":16416,"symbol":"__psynch_cvwait","symbolLocation":8,"imageIndex":21},{"imageOffset":27252,"symbol":"_pthread_cond_wait","symbolLocation":976,"imageIndex":22},{"imageOffset":458180,"symbol":"std::__fl::condition_variable::wait(std::__fl::unique_lock<std::__fl::mutex>&)","symbolLocation":24,"imageIndex":19},{"imageOffset":606432,"symbol":"fml::ConcurrentMessageLoop::WorkerMain()","symbolLocation":140,"imageIndex":19},{"imageOffset":608136,"symbol":"void* std::__fl::__thread_proxy[abi:nn210000]<std::__fl::tuple<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>>(void*)","symbolLocation":192,"imageIndex":19},{"imageOffset":26028,"symbol":"_pthread_start","symbolLocation":104,"imageIndex":22},{"imageOffset":6552,"symbol":"thread_start","symbolLocation":8,"imageIndex":22}]},{"id":57254079,"name":"dart:io EventHandler","threadState":{"x":[{"value":4},{"value":0},{"value":0},{"value":6178860312},{"value":16},{"value":6178859272},{"value":64871186054144},{"value":0},{"value":582000000},{"value":119},{"value":5497558140160},{"value":5497558140162},{"value":256},{"value":1},{"value":15360},{"value":15104},{"value":363},{"value":105553156170536},{"value":0},{"value":105553156292992},{"value":6178859272},{"value":67108864},{"value":2147483647},{"value":274877907},{"value":4294966296},{"value":1000000},{"value":2772089251},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4372128128},"cpsr":{"value":536875008},"fp":{"value":6178860912},"sp":{"value":6178859248},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4313523804},"far":{"value":0}},"frames":[{"imageOffset":26204,"symbol":"kevent","symbolLocation":8,"imageIndex":21},{"imageOffset":5267840,"symbol":"dart::bin::EventHandlerImplementation::EventHandlerEntry(unsigned long)","symbolLocation":304,"imageIndex":19},{"imageOffset":5382744,"symbol":"dart::bin::ThreadStart(void*)","symbolLocation":92,"imageIndex":19},{"imageOffset":26028,"symbol":"_pthread_start","symbolLocation":104,"imageIndex":22},{"imageOffset":6552,"symbol":"thread_start","symbolLocation":8,"imageIndex":22}]},{"id":57254080,"name":"Dart Profiler ThreadInterrupter","threadState":{"x":[{"value":260},{"value":0},{"value":90624},{"value":0},{"value":0},{"value":160},{"value":0},{"value":0},{"value":6179957272},{"value":0},{"value":0},{"value":2},{"value":2},{"value":0},{"value":0},{"value":0},{"value":305},{"value":105553162603616},{"value":0},{"value":105553162603520},{"value":105553162603592},{"value":6179959008},{"value":0},{"value":0},{"value":90624},{"value":91905},{"value":92160},{"value":4399689728,"symbolLocation":5352,"symbol":"dart::Symbols::symbol_handles_"},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4322454132},"cpsr":{"value":1610616832},"fp":{"value":6179957392},"sp":{"value":6179957248},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4313514016},"far":{"value":0}},"frames":[{"imageOffset":16416,"symbol":"__psynch_cvwait","symbolLocation":8,"imageIndex":21},{"imageOffset":27252,"symbol":"_pthread_cond_wait","symbolLocation":976,"imageIndex":22},{"imageOffset":5700412,"symbol":"dart::ConditionVariable::WaitMicros(dart::Mutex*, long long)","symbolLocation":128,"imageIndex":19},{"imageOffset":7174800,"symbol":"dart::ThreadInterrupter::ThreadMain(unsigned long)","symbolLocation":336,"imageIndex":19},{"imageOffset":6855872,"symbol":"dart::ThreadStart(void*)","symbolLocation":208,"imageIndex":19},{"imageOffset":26028,"symbol":"_pthread_start","symbolLocation":104,"imageIndex":22},{"imageOffset":6552,"symbol":"thread_start","symbolLocation":8,"imageIndex":22}]},{"id":57254081,"name":"Dart Profiler SampleBlockProcessor","threadState":{"x":[{"value":260},{"value":0},{"value":256},{"value":0},{"value":0},{"value":160},{"value":0},{"value":100000000},{"value":1281},{"value":0},{"value":0},{"value":2},{"value":2},{"value":0},{"value":0},{"value":0},{"value":305},{"value":105553162436096},{"value":0},{"value":105553162603648},{"value":105553162603720},{"value":1},{"value":100000000},{"value":0},{"value":256},{"value":1281},{"value":1536},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4322454176},"cpsr":{"value":2684358656},"fp":{"value":6181055120},"sp":{"value":6181054976},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4313514016},"far":{"value":0}},"frames":[{"imageOffset":16416,"symbol":"__psynch_cvwait","symbolLocation":8,"imageIndex":21},{"imageOffset":27296,"symbol":"_pthread_cond_wait","symbolLocation":1020,"imageIndex":22},{"imageOffset":5700396,"symbol":"dart::ConditionVariable::WaitMicros(dart::Mutex*, long long)","symbolLocation":112,"imageIndex":19},{"imageOffset":6876352,"symbol":"dart::SampleBlockProcessor::ThreadMain(unsigned long)","symbolLocation":220,"imageIndex":19},{"imageOffset":6855872,"symbol":"dart::ThreadStart(void*)","symbolLocation":208,"imageIndex":19},{"imageOffset":26028,"symbol":"_pthread_start","symbolLocation":104,"imageIndex":22},{"imageOffset":6552,"symbol":"thread_start","symbolLocation":8,"imageIndex":22}]},{"id":57254082,"name":"DartWorker","threadState":{"x":[{"value":260},{"value":0},{"value":3584},{"value":0},{"value":0},{"value":160},{"value":5},{"value":0},{"value":3585},{"value":0},{"value":0},{"value":2},{"value":2},{"value":0},{"value":0},{"value":0},{"value":305},{"value":288},{"value":0},{"value":4329626040},{"value":105553156156432},{"value":1},{"value":0},{"value":5},{"value":3584},{"value":3585},{"value":3840},{"value":4399689728,"symbolLocation":5352,"symbol":"dart::Symbols::symbol_handles_"},{"value":1000}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4322454176},"cpsr":{"value":2684358656},"fp":{"value":6182152768},"sp":{"value":6182152624},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4313514016},"far":{"value":0}},"frames":[{"imageOffset":16416,"symbol":"__psynch_cvwait","symbolLocation":8,"imageIndex":21},{"imageOffset":27296,"symbol":"_pthread_cond_wait","symbolLocation":1020,"imageIndex":22},{"imageOffset":5700396,"symbol":"dart::ConditionVariable::WaitMicros(dart::Mutex*, long long)","symbolLocation":112,"imageIndex":19},{"imageOffset":7178288,"symbol":"dart::ThreadPool::WorkerLoop(dart::ThreadPool::Worker*)","symbolLocation":512,"imageIndex":19},{"imageOffset":7178640,"symbol":"dart::ThreadPool::Worker::Main(unsigned long)","symbolLocation":116,"imageIndex":19},{"imageOffset":6855872,"symbol":"dart::ThreadStart(void*)","symbolLocation":208,"imageIndex":19},{"imageOffset":26028,"symbol":"_pthread_start","symbolLocation":104,"imageIndex":22},{"imageOffset":6552,"symbol":"thread_start","symbolLocation":8,"imageIndex":22}]},{"id":57254085,"name":"DartWorker","threadState":{"x":[{"value":260},{"value":0},{"value":512},{"value":0},{"value":0},{"value":160},{"value":4},{"value":999999000},{"value":513},{"value":0},{"value":0},{"value":2},{"value":2},{"value":0},{"value":0},{"value":0},{"value":305},{"value":57},{"value":0},{"value":4333813384},{"value":105553156167920},{"value":1},{"value":999999000},{"value":4},{"value":512},{"value":513},{"value":768},{"value":4399689728,"symbolLocation":5352,"symbol":"dart::Symbols::symbol_handles_"},{"value":1000}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4322454176},"cpsr":{"value":2684358656},"fp":{"value":6183250496},"sp":{"value":6183250352},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4313514016},"far":{"value":0}},"frames":[{"imageOffset":16416,"symbol":"__psynch_cvwait","symbolLocation":8,"imageIndex":21},{"imageOffset":27296,"symbol":"_pthread_cond_wait","symbolLocation":1020,"imageIndex":22},{"imageOffset":5700396,"symbol":"dart::ConditionVariable::WaitMicros(dart::Mutex*, long long)","symbolLocation":112,"imageIndex":19},{"imageOffset":7178288,"symbol":"dart::ThreadPool::WorkerLoop(dart::ThreadPool::Worker*)","symbolLocation":512,"imageIndex":19},{"imageOffset":7178640,"symbol":"dart::ThreadPool::Worker::Main(unsigned long)","symbolLocation":116,"imageIndex":19},{"imageOffset":6855872,"symbol":"dart::ThreadStart(void*)","symbolLocation":208,"imageIndex":19},{"imageOffset":26028,"symbol":"_pthread_start","symbolLocation":104,"imageIndex":22},{"imageOffset":6552,"symbol":"thread_start","symbolLocation":8,"imageIndex":22}]},{"id":57254086,"name":"DartWorker","threadState":{"x":[{"value":260},{"value":0},{"value":15360},{"value":0},{"value":0},{"value":160},{"value":61},{"value":0},{"value":15361},{"value":0},{"value":0},{"value":2},{"value":2},{"value":0},{"value":0},{"value":0},{"value":305},{"value":388},{"value":0},{"value":4327535832},{"value":105553156170512},{"value":1},{"value":0},{"value":61},{"value":15360},{"value":15361},{"value":15616},{"value":4399689728,"symbolLocation":5352,"symbol":"dart::Symbols::symbol_handles_"},{"value":1000}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4322454176},"cpsr":{"value":2684358656},"fp":{"value":6184348144},"sp":{"value":6184348000},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4313514016},"far":{"value":0}},"frames":[{"imageOffset":16416,"symbol":"__psynch_cvwait","symbolLocation":8,"imageIndex":21},{"imageOffset":27296,"symbol":"_pthread_cond_wait","symbolLocation":1020,"imageIndex":22},{"imageOffset":5700396,"symbol":"dart::ConditionVariable::WaitMicros(dart::Mutex*, long long)","symbolLocation":112,"imageIndex":19},{"imageOffset":6093452,"symbol":"dart::MutatorThreadPool::OnEnterIdleLocked(dart::MutexLocker*, dart::ThreadPool::Worker*)","symbolLocation":156,"imageIndex":19},{"imageOffset":7177900,"symbol":"dart::ThreadPool::WorkerLoop(dart::ThreadPool::Worker*)","symbolLocation":124,"imageIndex":19},{"imageOffset":7178640,"symbol":"dart::ThreadPool::Worker::Main(unsigned long)","symbolLocation":116,"imageIndex":19},{"imageOffset":6855872,"symbol":"dart::ThreadStart(void*)","symbolLocation":208,"imageIndex":19},{"imageOffset":26028,"symbol":"_pthread_start","symbolLocation":104,"imageIndex":22},{"imageOffset":6552,"symbol":"thread_start","symbolLocation":8,"imageIndex":22}]},{"id":57254091,"name":"DartWorker","threadState":{"x":[{"value":260},{"value":0},{"value":4096},{"value":0},{"value":0},{"value":160},{"value":4},{"value":801126000},{"value":4097},{"value":0},{"value":0},{"value":2},{"value":2},{"value":0},{"value":0},{"value":0},{"value":305},{"value":71},{"value":0},{"value":4329626040},{"value":105553156150096},{"value":1},{"value":801126000},{"value":4},{"value":4096},{"value":4097},{"value":4352},{"value":4399689728,"symbolLocation":5352,"symbol":"dart::Symbols::symbol_handles_"},{"value":1000}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4322454176},"cpsr":{"value":2684358656},"fp":{"value":6185445952},"sp":{"value":6185445808},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":4313514016},"far":{"value":0}},"frames":[{"imageOffset":16416,"symbol":"__psynch_cvwait","symbolLocation":8,"imageIndex":21},{"imageOffset":27296,"symbol":"_pthread_cond_wait","symbolLocation":1020,"imageIndex":22},{"imageOffset":5700396,"symbol":"dart::ConditionVariable::WaitMicros(dart::Mutex*, long long)","symbolLocation":112,"imageIndex":19},{"imageOffset":7178288,"symbol":"dart::ThreadPool::WorkerLoop(dart::ThreadPool::Worker*)","symbolLocation":512,"imageIndex":19},{"imageOffset":7178640,"symbol":"dart::ThreadPool::Worker::Main(unsigned long)","symbolLocation":116,"imageIndex":19},{"imageOffset":6855872,"symbol":"dart::ThreadStart(void*)","symbolLocation":208,"imageIndex":19},{"imageOffset":26028,"symbol":"_pthread_start","symbolLocation":104,"imageIndex":22},{"imageOffset":6552,"symbol":"thread_start","symbolLocation":8,"imageIndex":22}]}],
  "usedImages" : [
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4307877888,
    "size" : 655360,
    "uuid" : "0975afba-c46b-364c-bd84-a75daa9e455a",
    "path" : "\/usr\/lib\/dyld",
    "name" : "dyld"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4307582976,
    "CFBundleShortVersionString" : "0.1.0",
    "CFBundleIdentifier" : "com.nebulainfinity.japanLifeNavi",
    "size" : 16384,
    "uuid" : "cae6df76-9aef-3c99-811b-6c78c9cbbbc3",
    "path" : "\/Users\/USER\/Library\/Developer\/CoreSimulator\/Devices\/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4\/data\/Containers\/Bundle\/Application\/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190\/Runner.app\/Runner",
    "name" : "Runner",
    "CFBundleVersion" : "1"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4314497024,
    "size" : 2211840,
    "uuid" : "5c77f498-0fb1-3a2f-9722-2338da86d25e",
    "path" : "\/Users\/USER\/Library\/Developer\/CoreSimulator\/Devices\/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4\/data\/Containers\/Bundle\/Application\/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190\/Runner.app\/Runner.debug.dylib",
    "name" : "Runner.debug.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4309368832,
    "CFBundleShortVersionString" : "2.4.0",
    "CFBundleIdentifier" : "org.cocoapods.FBLPromises",
    "size" : 81920,
    "uuid" : "0bdad83c-f5d0-3081-8e47-cbc4aa53f733",
    "path" : "\/Users\/USER\/Library\/Developer\/CoreSimulator\/Devices\/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4\/data\/Containers\/Bundle\/Application\/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190\/Runner.app\/Frameworks\/FBLPromises.framework\/FBLPromises",
    "name" : "FBLPromises",
    "CFBundleVersion" : "1"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4307779584,
    "CFBundleShortVersionString" : "11.15.0",
    "CFBundleIdentifier" : "org.cocoapods.FirebaseAppCheckInterop",
    "size" : 16384,
    "uuid" : "6ff2ff85-5a78-35c1-81f4-936525d548f1",
    "path" : "\/Users\/USER\/Library\/Developer\/CoreSimulator\/Devices\/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4\/data\/Containers\/Bundle\/Application\/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190\/Runner.app\/Frameworks\/FirebaseAppCheckInterop.framework\/FirebaseAppCheckInterop",
    "name" : "FirebaseAppCheckInterop",
    "CFBundleVersion" : "1"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4318527488,
    "CFBundleShortVersionString" : "11.15.0",
    "CFBundleIdentifier" : "org.cocoapods.FirebaseAuth",
    "size" : 1638400,
    "uuid" : "3b3459bb-ca28-3bb0-b985-d5f2e7cddce4",
    "path" : "\/Users\/USER\/Library\/Developer\/CoreSimulator\/Devices\/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4\/data\/Containers\/Bundle\/Application\/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190\/Runner.app\/Frameworks\/FirebaseAuth.framework\/FirebaseAuth",
    "name" : "FirebaseAuth",
    "CFBundleVersion" : "1"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4309139456,
    "CFBundleShortVersionString" : "11.15.0",
    "CFBundleIdentifier" : "org.cocoapods.FirebaseAuthInterop",
    "size" : 16384,
    "uuid" : "3bd86be0-6cfb-3b38-b014-2d715e221fcb",
    "path" : "\/Users\/USER\/Library\/Developer\/CoreSimulator\/Devices\/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4\/data\/Containers\/Bundle\/Application\/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190\/Runner.app\/Frameworks\/FirebaseAuthInterop.framework\/FirebaseAuthInterop",
    "name" : "FirebaseAuthInterop",
    "CFBundleVersion" : "1"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4310777856,
    "CFBundleShortVersionString" : "11.15.0",
    "CFBundleIdentifier" : "org.cocoapods.FirebaseCore",
    "size" : 81920,
    "uuid" : "ddc6b862-cfaf-3e76-84f1-e5bafe7b96ad",
    "path" : "\/Users\/USER\/Library\/Developer\/CoreSimulator\/Devices\/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4\/data\/Containers\/Bundle\/Application\/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190\/Runner.app\/Frameworks\/FirebaseCore.framework\/FirebaseCore",
    "name" : "FirebaseCore",
    "CFBundleVersion" : "1"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4309221376,
    "CFBundleShortVersionString" : "11.15.0",
    "CFBundleIdentifier" : "org.cocoapods.FirebaseCoreExtension",
    "size" : 16384,
    "uuid" : "7a1408e9-74b0-30c4-8909-39d839222d0e",
    "path" : "\/Users\/USER\/Library\/Developer\/CoreSimulator\/Devices\/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4\/data\/Containers\/Bundle\/Application\/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190\/Runner.app\/Frameworks\/FirebaseCoreExtension.framework\/FirebaseCoreExtension",
    "name" : "FirebaseCoreExtension",
    "CFBundleVersion" : "1"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4311515136,
    "CFBundleShortVersionString" : "11.15.0",
    "CFBundleIdentifier" : "org.cocoapods.FirebaseCoreInternal",
    "size" : 163840,
    "uuid" : "95a316a0-9826-3db0-adcf-3beed47ea605",
    "path" : "\/Users\/USER\/Library\/Developer\/CoreSimulator\/Devices\/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4\/data\/Containers\/Bundle\/Application\/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190\/Runner.app\/Frameworks\/FirebaseCoreInternal.framework\/FirebaseCoreInternal",
    "name" : "FirebaseCoreInternal",
    "CFBundleVersion" : "1"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4312023040,
    "CFBundleShortVersionString" : "11.15.0",
    "CFBundleIdentifier" : "org.cocoapods.FirebaseInstallations",
    "size" : 114688,
    "uuid" : "5d1adfd9-1a13-328b-969f-ae0d00a0fd2f",
    "path" : "\/Users\/USER\/Library\/Developer\/CoreSimulator\/Devices\/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4\/data\/Containers\/Bundle\/Application\/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190\/Runner.app\/Frameworks\/FirebaseInstallations.framework\/FirebaseInstallations",
    "name" : "FirebaseInstallations",
    "CFBundleVersion" : "1"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4312907776,
    "CFBundleShortVersionString" : "4.5.0",
    "CFBundleIdentifier" : "org.cocoapods.GTMSessionFetcher",
    "size" : 327680,
    "uuid" : "ea6b0445-a438-3dfa-87ce-35956f96c5cc",
    "path" : "\/Users\/USER\/Library\/Developer\/CoreSimulator\/Devices\/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4\/data\/Containers\/Bundle\/Application\/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190\/Runner.app\/Frameworks\/GTMSessionFetcher.framework\/GTMSessionFetcher",
    "name" : "GTMSessionFetcher",
    "CFBundleVersion" : "1"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4312301568,
    "CFBundleShortVersionString" : "8.1.0",
    "CFBundleIdentifier" : "org.cocoapods.GoogleUtilities",
    "size" : 147456,
    "uuid" : "0a5b2568-a191-3233-81d9-08616d8d6aab",
    "path" : "\/Users\/USER\/Library\/Developer\/CoreSimulator\/Devices\/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4\/data\/Containers\/Bundle\/Application\/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190\/Runner.app\/Frameworks\/GoogleUtilities.framework\/GoogleUtilities",
    "name" : "GoogleUtilities",
    "CFBundleVersion" : "1"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4309581824,
    "CFBundleShortVersionString" : "101.0.0",
    "CFBundleIdentifier" : "org.cocoapods.RecaptchaInterop",
    "size" : 16384,
    "uuid" : "4e710d37-be16-3ef2-ac15-93eeecaee554",
    "path" : "\/Users\/USER\/Library\/Developer\/CoreSimulator\/Devices\/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4\/data\/Containers\/Bundle\/Application\/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190\/Runner.app\/Frameworks\/RecaptchaInterop.framework\/RecaptchaInterop",
    "name" : "RecaptchaInterop",
    "CFBundleVersion" : "1"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4307681280,
    "CFBundleShortVersionString" : "3.30910.0",
    "CFBundleIdentifier" : "org.cocoapods.nanopb",
    "size" : 32768,
    "uuid" : "7c853d26-e373-3c39-95c2-28f6ae749a80",
    "path" : "\/Users\/USER\/Library\/Developer\/CoreSimulator\/Devices\/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4\/data\/Containers\/Bundle\/Application\/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190\/Runner.app\/Frameworks\/nanopb.framework\/nanopb",
    "name" : "nanopb",
    "CFBundleVersion" : "1"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4311252992,
    "CFBundleShortVersionString" : "0.0.1",
    "CFBundleIdentifier" : "org.cocoapods.shared-preferences-foundation",
    "size" : 81920,
    "uuid" : "3bcb7d9c-3bd5-326e-aa8c-b64aa4569ce4",
    "path" : "\/Users\/USER\/Library\/Developer\/CoreSimulator\/Devices\/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4\/data\/Containers\/Bundle\/Application\/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190\/Runner.app\/Frameworks\/shared_preferences_foundation.framework\/shared_preferences_foundation",
    "name" : "shared_preferences_foundation",
    "CFBundleVersion" : "1"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4324311040,
    "CFBundleShortVersionString" : "3.51.1",
    "CFBundleIdentifier" : "org.cocoapods.sqlite3",
    "size" : 1409024,
    "uuid" : "16fbf7c0-909a-381c-bf7e-35ce72174354",
    "path" : "\/Users\/USER\/Library\/Developer\/CoreSimulator\/Devices\/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4\/data\/Containers\/Bundle\/Application\/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190\/Runner.app\/Frameworks\/sqlite3.framework\/sqlite3",
    "name" : "sqlite3",
    "CFBundleVersion" : "1"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4310548480,
    "CFBundleShortVersionString" : "0.0.1",
    "CFBundleIdentifier" : "org.cocoapods.sqlite3-flutter-libs",
    "size" : 16384,
    "uuid" : "00a57c8c-124d-3f54-a64d-4fa9a6e5d7fe",
    "path" : "\/Users\/USER\/Library\/Developer\/CoreSimulator\/Devices\/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4\/data\/Containers\/Bundle\/Application\/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190\/Runner.app\/Frameworks\/sqlite3_flutter_libs.framework\/sqlite3_flutter_libs",
    "name" : "sqlite3_flutter_libs",
    "CFBundleVersion" : "1"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4312612864,
    "CFBundleShortVersionString" : "0.0.1",
    "CFBundleIdentifier" : "org.cocoapods.url-launcher-ios",
    "size" : 81920,
    "uuid" : "2468a95b-55f8-33f3-a4c4-f815496b911e",
    "path" : "\/Users\/USER\/Library\/Developer\/CoreSimulator\/Devices\/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4\/data\/Containers\/Bundle\/Application\/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190\/Runner.app\/Frameworks\/url_launcher_ios.framework\/url_launcher_ios",
    "name" : "url_launcher_ios",
    "CFBundleVersion" : "1"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4366860288,
    "CFBundleShortVersionString" : "1.0",
    "CFBundleIdentifier" : "io.flutter.flutter",
    "size" : 32014336,
    "uuid" : "4c4c4472-5555-3144-a129-5b766c61c004",
    "path" : "\/Users\/USER\/Library\/Developer\/CoreSimulator\/Devices\/49D52B25-B21A-47E4-B8BD-CACC37D5FCA4\/data\/Containers\/Bundle\/Application\/1BF03B8E-80C7-40F6-9B82-BD8F8B4DB190\/Runner.app\/Frameworks\/Flutter.framework\/Flutter",
    "name" : "Flutter",
    "CFBundleVersion" : "1.0"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4310646784,
    "size" : 32768,
    "uuid" : "de4033bb-4a6b-317a-bda6-b3a408656844",
    "path" : "\/usr\/lib\/system\/libsystem_platform.dylib",
    "name" : "libsystem_platform.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4313497600,
    "size" : 245760,
    "uuid" : "8f54f386-9b41-376a-9ba3-9423bbabb1b6",
    "path" : "\/usr\/lib\/system\/libsystem_kernel.dylib",
    "name" : "libsystem_kernel.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4322426880,
    "size" : 65536,
    "uuid" : "48ca2121-5ca2-3e04-bc91-a33151256e77",
    "path" : "\/usr\/lib\/system\/libsystem_pthread.dylib",
    "name" : "libsystem_pthread.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4323524608,
    "size" : 49152,
    "uuid" : "997b234d-5c24-3e21-97d6-33b6853818c0",
    "path" : "\/Volumes\/VOLUME\/*\/libobjc-trampolines.dylib",
    "name" : "libobjc-trampolines.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 6443765760,
    "size" : 512708,
    "uuid" : "e0197e7b-9d61-356a-90b7-4be1270b82d5",
    "path" : "\/Volumes\/VOLUME\/*\/libsystem_c.dylib",
    "name" : "libsystem_c.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 6445539328,
    "size" : 99696,
    "uuid" : "0fc14bd2-2110-348c-8278-7a6fb63a7000",
    "path" : "\/Volumes\/VOLUME\/*\/libc++abi.dylib",
    "name" : "libc++abi.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 6442909696,
    "size" : 250520,
    "uuid" : "880f8664-cd53-3912-bdd5-5e3159295f7d",
    "path" : "\/Volumes\/VOLUME\/*\/libobjc.A.dylib",
    "name" : "libobjc.A.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 6446395392,
    "CFBundleShortVersionString" : "6.9",
    "CFBundleIdentifier" : "com.apple.CoreFoundation",
    "size" : 4309888,
    "uuid" : "4f6d050d-95ee-3a95-969c-3a98b29df6ff",
    "path" : "\/Volumes\/VOLUME\/*\/CoreFoundation.framework\/CoreFoundation",
    "name" : "CoreFoundation",
    "CFBundleVersion" : "4201"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 6444281856,
    "size" : 283072,
    "uuid" : "ec9ecf10-959d-3da1-a055-6de970159b9d",
    "path" : "\/Volumes\/VOLUME\/*\/libdispatch.dylib",
    "name" : "libdispatch.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 6755336192,
    "CFBundleShortVersionString" : "1.0",
    "CFBundleIdentifier" : "com.apple.GraphicsServices",
    "size" : 32192,
    "uuid" : "4e5b0462-6170-3367-9475-4ff8b8dfe4e6",
    "path" : "\/Volumes\/VOLUME\/*\/GraphicsServices.framework\/GraphicsServices",
    "name" : "GraphicsServices",
    "CFBundleVersion" : "1.0"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 6528032768,
    "CFBundleShortVersionString" : "1.0",
    "CFBundleIdentifier" : "com.apple.UIKitCore",
    "size" : 35792672,
    "uuid" : "196154ff-ba04-33cd-9277-98f9aa0b7499",
    "path" : "\/Volumes\/VOLUME\/*\/UIKitCore.framework\/UIKitCore",
    "name" : "UIKitCore",
    "CFBundleVersion" : "9126.2.4.1.111"
  },
  {
    "size" : 0,
    "source" : "A",
    "base" : 0,
    "uuid" : "00000000-0000-0000-0000-000000000000"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 6451228672,
    "CFBundleShortVersionString" : "6.9",
    "CFBundleIdentifier" : "com.apple.Foundation",
    "size" : 14100704,
    "uuid" : "c153116f-dd31-3fa9-89bb-04b47c1fa83d",
    "path" : "\/Volumes\/VOLUME\/*\/Foundation.framework\/Foundation",
    "name" : "Foundation",
    "CFBundleVersion" : "4201"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 6446243840,
    "size" : 151140,
    "uuid" : "96067617-d907-387c-9792-9c2a240c514d",
    "path" : "\/Volumes\/VOLUME\/*\/libsystem_info.dylib",
    "name" : "libsystem_info.dylib"
  }
],
  "sharedCache" : {
  "base" : 6442450944,
  "size" : 4230184960,
  "uuid" : "a6c0479d-4a05-3659-bf82-42eebf5fb5a0"
},
  "vmSummary" : "ReadOnly portion of Libraries: Total=2.0G resident=0K(0%) swapped_out_or_unallocated=2.0G(100%)\nWritable regions: Total=767.6M written=2035K(0%) resident=2035K(0%) swapped_out=0K(0%) unallocated=765.6M(100%)\n\n                                VIRTUAL   REGION \nREGION TYPE                        SIZE    COUNT (non-coalesced) \n===========                     =======  ======= \nActivity Tracing                   256K        1 \nFoundation                          16K        1 \nIOSurface                           16K        1 \nKernel Alloc Once                   32K        1 \nMALLOC                           627.9M       87 \nMALLOC guard page                  128K        8 \nSTACK GUARD                       56.5M       32 \nStack                             32.5M       32 \nVM_ALLOCATE                      107.7M      272 \n__DATA                            61.5M     1047 \n__DATA_CONST                     131.4M     1074 \n__DATA_DIRTY                       139K       13 \n__FONT_DATA                        2352        1 \n__LINKEDIT                       717.0M       25 \n__OBJC_RO                         62.5M        1 \n__OBJC_RW                         2771K        1 \n__TEXT                             1.3G     1089 \n__TPRO_CONST                       148K        2 \ndyld private memory                2.2G       16 \nmapped file                      103.6M       17 \npage table in kernel              2035K        1 \nshared memory                       16K        1 \n===========                     =======  ======= \nTOTAL                              5.3G     3723 \n",
  "legacyInfo" : {
  "threadTriggered" : {
    "queue" : "com.apple.main-thread"
  }
},
  "logWritingSignature" : "befe6ca0ad685b60555c43a836c0f5e45279f3e5",
  "roots_installed" : 0,
  "bug_type" : "309",
  "trmStatus" : 1,
  "trialInfo" : {
  "rollouts" : [
    {
      "rolloutId" : "648cada15dbc71671bb3aa1b",
      "factorPackIds" : [
        "65a81173096f6a1f1ba46525"
      ],
      "deploymentId" : 240000116
    },
    {
      "rolloutId" : "695fd05d8ca5554688521e5e",
      "factorPackIds" : [
        "695fd08781fcd20ded79c1d3",
        "695fd0d28ca5554688521e5f",
        "695fd09c8774dc09015a80e9",
        "695fd0b18774dc09015a80ea"
      ],
      "deploymentId" : 3
    }
  ],
  "experiments" : [

  ]
}
}

Model: Mac15,6, BootROM 13822.61.10, proc 11:5:6 processors, 18 GB, SMC 
Graphics: Apple M3 Pro, Apple M3 Pro, Built-In
Display: Color LCD, 3024 x 1964 Retina, Main, MirrorOff, Online
Memory Module: LPDDR5, Hynix
AirPort: spairport_wireless_card_type_wifi (0x14E4, 0x4388), wl0: Oct  3 2025 00:48:21 version 23.41.7.0.41.51.200 FWID 01-0473880e
IO80211_driverkit-1533.5 "IO80211_driverkit-1533.5" Nov 14 2025 18:26:34
AirPort: 
Bluetooth: Version (null), 0 services, 0 devices, 0 incoming serial ports
Network Service: Wi-Fi, AirPort, en0
Thunderbolt Bus: MacBook Pro, Apple Inc.
Thunderbolt Bus: MacBook Pro, Apple Inc.
Thunderbolt Bus: MacBook Pro, Apple Inc.
