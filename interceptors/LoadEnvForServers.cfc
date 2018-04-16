component {

    property name="envFileName" inject="commandbox:moduleSettings:commandbox-dotenv:fileName";
    property name="propertyFile" inject="provider:PropertyFile@propertyFile";

    function onServerStart(interceptData) {
        var webRoot = interceptData.serverInfo.webRoot;
        var envStruct = getEnvStruct( "#webRoot#/#envFileName#" );
        for (var key in envStruct) {
            // Append to the JVM args
            interceptData.serverInfo.jvmArgs &= ' "-D#key#=#envStruct[key]#"';
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
