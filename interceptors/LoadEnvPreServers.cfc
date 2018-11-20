component {
    property name="moduleSettings" inject="commandbox:moduleSettings:commandbox-dotenv";
    property name="envFileService" inject="EnvironmentFileService@commandbox-dotenv";
    property name='consoleLogger' inject='logbox:logger:console';

    function preServerStart(interceptData) {
        var webRoot = interceptData.serverDetails.serverInfo.webRoot;
        var envStruct = envFileService.getEnvStruct( "#webRoot#/#moduleSettings.fileName#" );
        if( !structIsEmpty( envStruct ) && moduleSettings.printOnLoad ) {
            consoleLogger.info( "commandbox-dotenv: Loading Java properties from #webRoot##moduleSettings.fileName#" );
        }
        
        // Load env vars into CLI
        envFileService.loadEnvToCLI( envStruct );
    }

}