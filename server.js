var server = require('webserver').create();
var service = server.listen(8080, function(request, response) {
	var page = require('webpage').create(),
		system = require('system'),
		address, output, size;

    page.viewportSize = { width: 1280, height: 1024 };

	// TODO: parameterize URL and output.

    page.open("http://g0v.tw", function (status) {
        if (status !== 'success') {
            console.log('Unable to load the address!');
        } else {
            page.render("/tmp/out.png");
        }
    });

    response.statusCode = 200;
	response.setHeader("X-Accel-Redirect", "/tmp/out.png");
	response.write("");
    response.close();
});
