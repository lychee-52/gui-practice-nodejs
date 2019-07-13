var http = require('http');
var fs = require('fs');
var ejs = require('ejs');

var hello = fs.readFileSync('./pkglist.ejs', 'utf8');
 
var server = http.createServer();
server.on('request', doRequest);
server.listen(1234);
console.log('Server running!');
 
// リクエストの処理
function doRequest(req, res) {
    if (req.method == "GET") {
	var hello2 = ejs.render(hello, {
            title:"タイトルです",
            content:"これはサンプルで作成したテンプレートです。",
	    cb: ['', '', ''],
	});
	res.writeHead(200, {'Content-Type': 'text/html'});
	res.write(hello2);
	res.end();
    } else {
	var data = '';
	req.on('data', function(chunk) {data += chunk}).on('end', function() {
	    var args = data.split('&');
	    var hash, result = {};
	    for (var i=0; i<args.length; i++) {
		hash = args[i].split('=');
		if ( hash[1] == 'on' ) {
		    result[hash[0]] = 'checked';
		} else {
		    result[hash[0]] = '';
		}
	    }
	    var hello2 = ejs.render(hello, {
		title:"タイトルです",
		content:data,
		cb: [result['req1'],
		     result['req2'],
		     result['req3']],
	    });
	    res.writeHead(200, {'Content-Type': 'text/html'});
	    res.write(hello2);
	    res.end();
	})
    }
}
