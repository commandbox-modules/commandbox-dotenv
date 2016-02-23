component {

	function configure() {
		// required function
	}

	function onServerStart(interceptData) {
		var webRoot = interceptData.serverInfo.webRoot;
		var envFilePath = '#webRoot#/.env';

		if (fileExists(envFilePath)) {
			var envFile = fileRead(envFilePath);
			if (isJSON(envFile)) {
				var envJSON = deserializeJSON(envFile);
				for (var key in envJSON) {
					interceptData.serverInfo.jvmArgs &= ' -D#key#=#envJSON[key]#';
				}
			}
		}
	}

}