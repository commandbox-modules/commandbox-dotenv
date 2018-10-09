/**
 * Service for working with dotenv files
 */ 
component singleton="true" {

    property name="propertyFile" inject="provider:PropertyFile@propertyFile";

    public function getEnvStruct( envFilePath ) {
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