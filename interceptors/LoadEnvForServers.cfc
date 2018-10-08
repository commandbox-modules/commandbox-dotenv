component {

    property name="envFileName" inject="commandbox:moduleSettings:commandbox-dotenv:fileName";
    property name="envFileService" inject="EnvironmentFileService@commandbox-dotenv";
    property name='consoleLogger' inject='logbox:logger:console';

    function onServerStart(interceptData) {
        var webRoot = interceptData.serverInfo.webRoot;
        var envStruct = envFileService.getEnvStruct( "#webRoot#/#envFileName#" );
        for (var key in envStruct) {
            // Append to the JVM args
            interceptData.serverInfo.jvmArgs &= ' "-D#key#=#envStruct[key]#"';
        }
        if( !structIsEmpty( envStruct ) ) {
            consoleLogger.info( "Server JVM arguments loaded from #webRoot##envFileName#" );
        }
    }

}