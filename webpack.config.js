const path = require('path');
const webpack = require('webpack');
const HTMLWebpackPlugin = require('html-webpack-plugin');
const uglifyJsPlugin = require('uglifyjs-webpack-plugin');
const config = require('config');

/* -------------------------------------------------*/

const plugins = [
    new HTMLWebpackPlugin({
        template: path.resolve(__dirname, 'index.html')
    }),
    new webpack.HotModuleReplacementPlugin()
];

if( config.get('uglify') ) {
    plugins.push( new uglifyJsPlugin( {
        sourceMap: config.get('sourcemap')
    } ) );
}

/* -------------------------------------------------*/

module.exports = {
    entry: ['babel-polyfill', './src/index.js'],
    output: {
        library: 'HeritageJS',
        libraryTarget: 'umd',
        libraryExport: 'default',
        path: path.resolve(__dirname, 'dist'),
        filename: 'index.js',
        publicPath: config.get('publicPath')
    },
    module: {
        rules: [
            {
                test: /\.js$/,
                exclude: /node_modules/,
                use: ['babel-loader']
            },
            {
                test: /\.scss$/,
                use: ['style-loader', 'css-loader', 'postcss-loader', 'sass-loader']
            }
        ]
    },
    plugins: plugins,
    devServer: {
        historyApiFallback: true,
        open: config.get('open')
    }
};
