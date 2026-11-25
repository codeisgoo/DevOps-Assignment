const test = require('node:test');
const assert = require('node:assert/strict');
const request = require('supertest');

const app = require('./app');

test('GET /health returns healthy status', async () => {
    const response = await request(app).get('/health');

    assert.equal(response.status, 200);
    assert.equal(response.body.status, 'healthy');
});

test('GET /items returns items', async () => {
    const response = await request(app).get('/items');

    assert.equal(response.status, 200);
    assert.equal(response.body.items.length, 3);
    assert.equal(response.body.items[0].name, 'Laptop');
});
