component {

	property name="moduleSettings"	inject="commandbox:moduleSettings:commandbox-dotenv";
	property name="envFileService"	inject="EnvironmentFileService@commandbox-dotenv";
	property name="consoleLogger"	inject="logbox:logger:console";
	property name="fileSystemUtil"	inject="FileSystem";
	property name='configService'	inject='configService';
	property name='wirebox'			inject='wirebox';

	function preServerStart(interceptData) {
		var webRoot = variables.fileSystemUtil.normalizeSlashes( arguments.interceptData.serverDetails.serverInfo.webRoot );
		var webRootEnvFile = webRoot.listAppend( variables.moduleSettings.fileName, "/", false );
		var envStruct = variables.envFileService.getEnvStruct( webRootEnvFile );
		if ( !structIsEmpty( envStruct ) && variables.moduleSettings.printOnLoad ) {
			variables.consoleLogger.info( "commandbox-dotenv: Loading server environment variables from #webRootEnvFile#" );
		}

		if ( variables.moduleSettings.checkEnvPreServerStart ) {
			var envStruct = variables.envFileService.getEnvStruct( webRootEnvFile );
			var webRootEnvExampleFile = webRoot.listAppend( variables.moduleSettings.exampleFileName, "/", false );
			var envExampleStruct = variables.envFileService.getEnvStruct( webRootEnvExampleFile );
			var missingKeys = variables.envFileService.diff( envExampleStruct, envStruct );
			if ( !missingKeys.isEmpty() ) {
				throw(
					type = "commandException",
					message = "The [#moduleSettings.fileName#] file is missing keys from the #moduleSettings.exampleFileName#. You can populate your #moduleSettings.fileName# with the new settings using `dotenv populate --new`",
					detail = "Missing keys: [ #missingKeys.toList( ", " )# ]"
				);
			}
		}

		// Load env vars into CLI
		variables.envFileService.loadEnvToCLI( envStruct );
        
		// It's possible two env files get loaded if there is one in the web root of the server AND another one specified in the server.json
		var defaults = variables.configService.getSetting( "server.defaults", {} );
		var serverJSON = arguments.interceptData.serverDetails.serverJSON;
		var serverinfo = arguments.interceptData.serverDetails.serverInfo;
        
		var serverEnvFile = "";
		// First look for a server.defaults config setting
		if ( defaults.keyExists( "dotenvFile" ) && len( defaults.dotenvFile ) ) {
			serverEnvFile = defaults.dotenvFile.listMap( ( f ) => variables.fileSystemUtil.resolvePath( f, webRoot ) );
		}
        // Then look for a key in the actual server.json
        if ( serverJSON.keyExists( "dotenvFile" ) && len( serverJSON.dotenvFile ) ) {
        	serverEnvFile = serverEnvFile.listAppend(
        		serverJSON.dotenvFile.listMap( ( f ) => variables.fileSystemUtil.resolvePath( f, getDirectoryFromPath( serverInfo.serverConfigFile ) ) )
        	);
        }
        // If there isn't a envFile for this server, ignore it.
        if ( !len( serverEnvFile ) ) {
        	return;
        }
        
		variables.wirebox.getInstance( "Globber" )
			.setPattern( serverEnvFile )
			.apply( ( f ) => {
				f = variables.fileSystemUtil.normalizeSlashes( f );
				// If it's the same as the one we loaded above, ignore it
				if ( f == webRootEnvFile ) {
					return;
				}
				if ( variables.moduleSettings.printOnLoad ) {
					variables.consoleLogger.info( "commandbox-dotenv: loading server dotenvFile from [#f#]" );
				}
				variables.envFileService.loadEnvToCLI(
					envStruct = variables.envFileService.getEnvStruct( serverEnvFile )
				);
			} );
	}

}
