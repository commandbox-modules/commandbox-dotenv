component {

    property name="envFileName" inject="commandbox:moduleSettings:commandbox-dotenv:fileName";
    property name="envFileService" inject="EnvironmentFileService@commandbox-dotenv";

    function onServerStart(interceptData) {
        var webRoot = interceptData.serverInfo.webRoot;
        var envStruct = envFileService.getEnvStruct( "#webRoot#/#envFileName#" );
        for (var key in envStruct) {
            // Append to the JVM args
            interceptData.serverInfo.jvmArgs &= ' "-D#key#=#envStruct[key]#"';
        }
    }

}
