component {
    property name="moduleSettings"	inject="commandbox:moduleSettings:commandbox-dotenv";
    property name="envFileService"	inject="EnvironmentFileService@commandbox-dotenv";
    property name="consoleLogger"	inject="logbox:logger:console";
    property name="fileSystemUtil"	inject="FileSystem";
    property name='configService'	inject='configService';
    property name='wirebox'			inject='wirebox';

    function preServerStart(interceptData) {
        var webRoot = interceptData.serverDetails.serverInfo.webRoot;
        webRoot = fileSystemUtil.normalizeSlashes( webRoot );
        var webRootEnvFile = "#webRoot.listAppend( moduleSettings.fileName, '/', false )#";
        var envStruct = envFileService.getEnvStruct( webRootEnvFile );
        if( !structIsEmpty( envStruct ) && moduleSettings.printOnLoad ) {
            consoleLogger.info( "commandbox-dotenv: Loading server environment variables from #webRootEnvFile#" );
        }

        if ( moduleSettings.checkEnvPreServerStart ) {
            var envStruct = envFileService.getEnvStruct( "#webRootEnvFile#" );
            var envExampleStruct = envFileService.getEnvStruct( "#webRoot#/#moduleSettings.exampleFileName#" );
            var missingKeys = envFileService.diff( envExampleStruct, envStruct );
            if ( !missingKeys.isEmpty() ) {
                throw(
                    type = "commandException",
                    message = "The [#moduleSettings.fileName#] file is missing keys from the #moduleSettings.exampleFileName#. You can populate your #moduleSettings.fileName# with the new settings using `dotenv populate --new`",
                    detail = "Missing keys: [ #missingKeys.toList( ", " )# ]"
                )
            }
        }

        // Load env vars into CLI
        envFileService.loadEnvToCLI( envStruct );
        
        // It's possible two env files get loaded if there is one in the web root of the server AND another one specified in the server.json
        
    	var defaults = configService.getSetting( 'server.defaults', {} );
        var serverJSON = interceptData.serverDetails.serverJSON;
        var serverinfo = interceptData.serverDetails.serverInfo;
        
        var serverEnvFile = '';
        // First look for a server.defaults config setting
        if( defaults.keyExists( 'dotenvFile' ) && len( defaults.dotenvFile ) ) {
        	serverEnvFile = defaults.dotenvFile.listMap( (f)=>FileSystemUtil.resolvePath( f, webRoot ) );
        }
        // Then look for a key in the actual server.json
        if( serverJSON.keyExists( 'dotenvFile' ) && len( serverJSON.dotenvFile ) ) {
        	serverEnvFile = serverEnvFile.listAppend(
        		serverJSON.dotenvFile.listMap( (f)=>FileSystemUtil.resolvePath( f, getDirectoryFromPath( serverInfo.serverConfigFile ) ) )
        	);
        }
        // If there isn't a envFile for this server, ignore it.
        if( !len( serverEnvFile ) ) {
        	return;
        }
        
        wirebox.getInstance( 'Globber' )
        	.setPattern( serverEnvFile )
        	.apply( (f)=>{
                f = fileSystemUtil.normalizeSlashes( f );
                // If it's the same as the one we loaded above, ignore it
                if( f == webRootEnvFile ) {
                	return;
                }
		        if( moduleSettings.printOnLoad ) {
		            consoleLogger.info( "commandbox-dotenv: loading server dotenvFile from [#f#]" );
		        }
		        envFileService.loadEnvToCLI( envStruct=envFileService.getEnvStruct( serverEnvFile ) );
        	} );

    }

}
