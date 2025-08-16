const path = require("path")
const webpack = require("webpack")

const mode = process.env.NODE_ENV === 'development' ? 'development' : 'production'

module.exports = {
  mode,
  devtool: mode === 'development' ? "eval-source-map" : "source-map",
  entry: {
    application: "./app/javascript/application.js",
    staff: "./app/javascript/staff.js",
    admin: "./app/javascript/admin.js",
    customer: "./app/javascript/customer.js"
  },
  output: {
    filename: "[name].js",
    sourceMapFilename: "[file].map",
    path: path.resolve(__dirname, '..', '..', "app/assets/builds"),
    clean: true
  },
  resolve: {
    extensions: ['.js', '.jsx', '.ts', '.tsx'],
    modules: [
      path.resolve(__dirname, '..', '..', 'app/javascript'),
      'node_modules'
    ]
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env'],
            cacheDirectory: true
          }
        }
      }
    ]
  },
  plugins: [
    new webpack.optimize.LimitChunkCountPlugin({
      maxChunks: 1
    }),
    // Rails 8 optimization: Define environment variables
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify(mode)
    })
  ],
  // Rails 8 performance optimization
  optimization: {
    minimize: mode === 'production',
    splitChunks: false
  },
  // Rails 8 development server configuration
  devServer: {
    hot: false,
    liveReload: false
  }
}
