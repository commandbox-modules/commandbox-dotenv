component {

	function configure() {
		settings = {
			'fileName' = '.env',
			'printOnLoad' = false
		};

		interceptors = [
			{ class = "#moduleMapping#.interceptors.LoadEnvForCommands" },
			{ class = "#moduleMapping#.interceptors.LoadEnvForServers" },
			{ class = "#moduleMapping#.interceptors.LoadEnvPreServers" },
		];
	}

}
