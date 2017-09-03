component {

	function configure() {
		settings = {
			fileName = '.env'
		};

		interceptors = [
			{ class = "#moduleMapping#.interceptors.LoadEnvForCommands" },
			{ class = "#moduleMapping#.interceptors.LoadEnvForServers" }
		];
	}

}
