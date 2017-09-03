component {

    property name="envFileName" inject="commandbox:moduleSettings:commandbox-dotenv:fileName";
    property name="propertyFile" inject="provider:PropertyFile@propertyFile";
    property name="javaSystem" inject="java:java.lang.System";
    property name="fileSystemUtil" inject="FileSystem";

    function onCLIStart( interceptData ) {
        var directory = fileSystemUtil.resolvePath( "" );
        var envStruct = getEnvStruct( "#directory#/#envFileName#" );
        for (var key in envStruct) {
            javaSystem.setProperty( key, envStruct[ key ] );
        }
    }

    private function getEnvStruct( envFilePath ) {
        if ( ! fileExists( envFilePath ) ) {
            return {};
        }

        var envFile = fileRead( envFilePath );
        if ( isJSON( envFile ) ) {
            return deserializeJSON( envFile );
        }

        return propertyFile.get()
            .load( envFilePath )
            .getAsStruct();
    }
}
