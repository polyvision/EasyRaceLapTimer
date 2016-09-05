var path = require("path");
var webpack = require('webpack');

module.exports = {
  context: __dirname,
  entry: {
    main:  "./webpack/main.js",
  },
  output: {
    path: path.join(__dirname, 'app', 'assets', 'javascripts'),
    filename: "main.js",
    publicPath: "/js/",
    devtoolModuleFilenameTemplate: '[resourcePath]',
    devtoolFallbackModuleFilenameTemplate: '[resourcePath]?[hash]'
  },
  resolve: {
    extensions: ["", ".jsx", ".cjsx", ".coffee", ".js"]
  },
  module: {
    loaders: [
      { test: /\.js$/, loader: 'babel-loader'},
      { test: /\.jsx$/, loader: "jsx-loader?insertPragma=React.DOM" }
    ]
  },
  plugins: [
    new webpack.ProvidePlugin({
      'React': 'react',
      'Marty': 'marty',
    })
  ]
}
