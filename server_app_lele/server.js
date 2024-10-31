const express = require('express');
const app = express();
const hostname = '127.0.0.1'
const port = 8000;

const products =  [
    {
        id: 1,
        name: 'Product 1',
        price: 100000
    },
    {
        id: 2,
        name: 'Product 2',
        price: 200000
    },
    {
        id: 3,
        name: 'Product 3',
        price: 300000
    },
]

function get_products(id) {
    return products.find(p => p.id == id);
}

app.get('/', (req, res) => {
  res.json(products);
}); 

app.get('/products', (req, res) => {
  res.json(products);
});

app.get('/product/:id', (req, res) => {
  res.json(get_products(req.params.id));
});

app.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}`);
});