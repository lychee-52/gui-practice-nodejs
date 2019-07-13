default:

prepare-nodejs:
	cd /usr/local; \
	wget https://nodejs.org/dist/v10.16.0/node-v10.16.0-linux-x64.tar.xz; \
	tar xvf node-v10.16.0-linux-x64.tar.xz; \
	ln -s node-v10.16.0-linux-x64 node; \
	export PATH="/usr/local/node/bin:$${PATH}"

prepare-ejs:
	npm install ejs
