component {
    property name="moduleSettings" inject="commandbox:moduleSettings:commandbox-dotenv";
    property name="envFileService" inject="EnvironmentFileService@commandbox-dotenv";
    property name="consoleLogger"  inject="logbox:logger:console";
    property name="fileSystemUtil" inject="FileSystem";


    function preServerStart(interceptData) {
        var webRoot = interceptData.serverDetails.serverInfo.webRoot;
        var envStruct = envFileService.getEnvStruct( "#webRoot#/#moduleSettings.fileName#" );
        if( !structIsEmpty( envStruct ) && moduleSettings.printOnLoad ) {
            consoleLogger.info( "commandbox-dotenv: Loading environment variables from #webRoot##moduleSettings.fileName#" );
        }

        if ( moduleSettings.checkEnvPreServerStart ) {
            var envStruct = envFileService.getEnvStruct( "#webRoot#/#moduleSettings.fileName#" );
            var envExampleStruct = envFileService.getEnvStruct( "#webRoot#/#moduleSettings.exampleFileName#" );
            var missingKeys = envFileService.diff( envExampleStruct, envStruct );
            if ( !missingKeys.isEmpty() ) {
                throw(
                    type = "InvalidEnvCheck",
                    message = "The [#moduleSettings.fileName#] file is missing keys from the #moduleSettings.exampleFileName#. You can populate your #moduleSettings.fileName# with the new settings using `dotenv populate --new`",
                    detail = "Missing keys: [ #missingKeys.toList( ", " )# ]"
                )
            }
        }

        // Load env vars into CLI
        envFileService.loadEnvToCLI( envStruct );
    }

}
