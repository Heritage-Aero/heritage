const express = require('express');
const app = express();

app.use('/', express.static('./dist'))

app.listen(4000, function() {
  console.log('listening on 4k');
})