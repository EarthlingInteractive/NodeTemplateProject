import { Server } from "./n2r-server";
import express from "express";

const n2rServer = new Server();
const app = express();

app.get('/', (req, res, next) => {
	res.contentType('text/plain');
	res.send("Welcome to NodeN2R!");
});

app.use(n2rServer.expressHandler);

var port = 4000;

const argv = process.argv;
for( var i=2; i<argv.length; ++i ) {
	if( argv[i] == '-port' ) {
		port = argv[++i]|0;
	} else {
		process.stderr.write("Unrecognized option: "+argv[i]+"\n");
		process.exit(1);
	}
}

console.log("Listening on port "+port);
app.listen(port);
