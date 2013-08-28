var page = require('webpage').create(),
    system = require('system'),
    address, output, size;

if (system.args.length != 3) {
    phantom.exit(1);
} else {
    address = system.args[1];
    output = system.args[2];

	if (output.substr(-4) !== ".png") {
		phantom.exit();
	}

    page.viewportSize = { width: 1280, height: 1024 };

    page.open(address, function (status) {
        if (status !== 'success') {
            console.log('Unable to load the address!');
            phantom.exit();
        } else {
            window.setTimeout(function () {
                page.render(output);
                phantom.exit();
            }, 200);
        }
    });
}
