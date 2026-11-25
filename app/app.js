
const express = require('express');

const app = express();

const appMessage =
    process.env.APP_MESSAGE || 'Local development environment';

const items = [
    { id: 1, name: 'Laptop' },
    { id: 2, name: 'Keyboard' },
    { id: 3, name: 'Mouse' }
];

// Health check endpoint
app.get('/health', (req, res) => {
    res.status(200).json({
        status: 'healthy'
    });
});

// Items endpoint
app.get('/items', (req, res) => {
    res.status(200).json({
        message: appMessage,
        items
    });
});

module.exports = app;
