component {
    property name="moduleSettings" inject="commandbox:moduleSettings:commandbox-dotenv";
    property name="envFileService" inject="EnvironmentFileService@commandbox-dotenv";
    property name="fileSystemUtil" inject="FileSystem";
    property name='consoleLogger' inject='logbox:logger:console';

    function onCLIStart( interceptData ) {
        var directory = fileSystemUtil.resolvePath( "" );
        var envStruct = envFileService.getEnvStruct( "#directory#/#moduleSettings.fileName#" );
        if( !structIsEmpty( envStruct ) && moduleSettings.printOnLoad ) {
            consoleLogger.info( "commandbox-dotenv: Loading environment variables from #directory##moduleSettings.fileName#" );
        }
        
        // Load env vars into CLI
        envFileService.loadEnvToCLI( envStruct );
    }

    function preCommandParamProcess( interceptData ) {
        var directory = fileSystemUtil.resolvePath( "" );
        var envStruct = envFileService.getEnvStruct( "#directory#/#moduleSettings.fileName#" );
        if( !structIsEmpty( envStruct ) && moduleSettings.printOnLoad ) {
            consoleLogger.info( "commandbox-dotenv: Loading environment variables from #directory##moduleSettings.fileName#" );
        }
        
        // Load env vars into CLI
        envFileService.loadEnvToCLI( envStruct );
    }

}