component {

    property name="envFileName" inject="commandbox:moduleSettings:commandbox-dotenv:fileName";
    property name="envFileService" inject="EnvironmentFileService@commandbox-dotenv";
    property name="javaSystem" inject="java:java.lang.System";
    property name="fileSystemUtil" inject="FileSystem";

    function onCLIStart( interceptData ) {
        var directory = fileSystemUtil.resolvePath( "" );
        var envStruct = envFileService.getEnvStruct( "#directory#/#envFileName#" );
        for (var key in envStruct) {
            javaSystem.setProperty( key, envStruct[ key ] );
        }
    }

}
