component {

    property name="envFileName" inject="commandbox:moduleSettings:commandbox-dotenv:fileName";
    property name="envFileService" inject="EnvironmentFileService@commandbox-dotenv";
    property name='consoleLogger' inject='logbox:logger:console';

    function onServerStart(interceptData) {
        var webRoot = interceptData.serverInfo.webRoot;
        var envStruct = envFileService.getEnvStruct( "#webRoot#/#envFileName#" );
        if( !structIsEmpty( envStruct ) ) {
            consoleLogger.info( "commandbox-dotenv: Setting server JVM arguments from #webRoot##envFileName#" );
        }
        for (var key in envStruct) {
            // Append to the JVM args
            interceptData.serverInfo.jvmArgs &= ' "-D#key#=#envStruct[key]#"';
        }
    }

}