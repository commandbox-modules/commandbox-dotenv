component {

    property name="envFileName" inject="commandbox:moduleSettings:commandbox-dotenv:fileName";
    property name="printOnLoad" inject="commandbox:moduleSettings:commandbox-dotenv:printOnLoad";
    property name="envFileService" inject="EnvironmentFileService@commandbox-dotenv";
    property name="javaSystem" inject="java:java.lang.System";
    property name='consoleLogger' inject='logbox:logger:console';

    function preServerStart(interceptData) {
        var webRoot = interceptData.serverDetails.serverInfo.webRoot;
        var envStruct = envFileService.getEnvStruct( "#webRoot#/#envFileName#" );
        if( !structIsEmpty( envStruct ) ) {
            consoleLogger.info( "commandbox-dotenv: Loading Java properties from #webRoot##envFileName#" );
        }
        for (var key in envStruct) {
            javaSystem.setProperty( key, envStruct[ key ] );
            if( printOnLoad ) {
                consoleLogger.info( "commandbox-dotenv: #key#=#envStruct[ key ]#" );
            }
        }
    }

}