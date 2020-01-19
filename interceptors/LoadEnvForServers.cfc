component {
    property name="moduleSettings" inject="commandbox:moduleSettings:commandbox-dotenv";
    property name="envFileService" inject="EnvironmentFileService@commandbox-dotenv";
    property name='consoleLogger' inject='logbox:logger:console';

    function onServerStart(interceptData) {
        var webRoot = interceptData.serverInfo.webRoot;
        var envStruct = envFileService.getEnvStruct( "#webRoot#/#moduleSettings.fileName#" );
        if( !structIsEmpty( envStruct ) && moduleSettings.printOnLoad ) {
            consoleLogger.info( "commandbox-dotenv: Setting server JVM arguments from #webRoot##moduleSettings.fileName#" );
        }
        for (var key in envStruct) {
            // Append to the JVM args
            interceptData.serverInfo.jvmArgs &= ' "-D#key#=#toString( envStruct[key] ).replaceNoCase( '\', '\\', 'all' ).replaceNoCase( '"', '\"', 'all' )#"';
        }
    }

}