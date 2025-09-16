component {

    property name="moduleSettings" inject="commandbox:moduleSettings:commandbox-dotenv";
    property name="envFileService" inject="EnvironmentFileService@commandbox-dotenv";
    property name="fileSystemUtil" inject="FileSystem";
    property name="consoleLogger"  inject="logbox:logger:console";
	property name="configService"  inject="configService";

    function onCLIStart( interceptData ) {
        var gloablEnv = fileSystemUtil.resolvePath( moduleSettings.globalEnvFile );
        
        // Stub out this file for them just so it's easier to find and use.
        if ( ! fileExists( gloablEnv ) ) {
            try {
        	    fileWrite( gloablEnv, "## Add environment variables to be loaded into CommandBox when it starts#chr( 13 )##chr( 10 )### Variables are in the form of foo=bar, one per line" );
            } catch( any e ) {
                // No permissions
            }
        }
        
        var envStruct = envFileService.getEnvStruct( gloablEnv );
        if ( ! structIsEmpty( envStruct ) ) {

            if( moduleSettings.printOnLoad ) {
                consoleLogger.info( "commandbox-dotenv: Loading environment variables from #gloablEnv#" );
            }

            envFileService.loadEnvToCLI( envStruct );
            
            if( !isNull( configService ) ) {
                // Reload config to pickup any changes
                configService.loadOverrides();
            }
        }
        
    }

}
