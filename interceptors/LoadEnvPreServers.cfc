component {

    property name="envFileName" inject="commandbox:moduleSettings:commandbox-dotenv:fileName";
    property name="envFileService" inject="EnvironmentFileService@commandbox-dotenv";
    property name="javaSystem" inject="java:java.lang.System";
    property name='consoleLogger' inject='logbox:logger:console';

    function preServerStart(interceptData) {
        var webRoot = interceptData.serverDetails.serverInfo.webRoot;
        var envStruct = envFileService.getEnvStruct( "#webRoot#/#envFileName#" );
        for (var key in envStruct) {
            javaSystem.setProperty( key, envStruct[ key ] );
        }
        if( !structIsEmpty( envStruct ) ) {
            consoleLogger.info( "Java properties loaded from #webRoot##envFileName#" );
        }
    }

}