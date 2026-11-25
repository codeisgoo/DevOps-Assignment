module.exports = [
    {
        files: ['**/*.js'],
        languageOptions: {
            ecmaVersion: 'latest',
            sourceType: 'commonjs',
            globals: {
                require: 'readonly',
                module: 'readonly',
                process: 'readonly',
                console: 'readonly'
            }
        },
        rules: {
            'no-unused-vars': 'error',
            'no-undef': 'error',
            'semi': ['error', 'always'],
            'quotes': ['error', 'single']
        }
    }
];
