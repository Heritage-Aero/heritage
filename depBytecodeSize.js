const json = require(`./build/contracts/${process.argv[2]}`);

const str = json.deployedBytecode
console.log(str.length + " characters, " + Buffer.byteLength(str, 'utf8') + " bytes");
