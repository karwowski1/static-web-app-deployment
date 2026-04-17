const express = require('express');
const app = express();
const port = 3000;

app.get('/health', (req, res) => res.send({ status: 'OK' }));
app.get('/tasks', (req, res) => res.send([]));

app.listen(port, () => console.log(`API listening on port ${port}`));