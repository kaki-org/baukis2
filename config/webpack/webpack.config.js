const path = require("path")
const webpack = require("webpack")
const MiniCssExtractPlugin = require("mini-css-extract-plugin")

const mode = process.env.NODE_ENV === 'development' ? 'development' : 'production'

module.exports = {
  mode,
  devtool: mode === 'development' ? "eval-source-map" : "source-map",
  entry: {
    application: "./app/javascript/application.js",
    staff: ["./app/javascript/staff.js", "./app/assets/stylesheets/staff.scss"],
    admin: ["./app/javascript/admin.js", "./app/assets/stylesheets/admin.scss"],
    customer: ["./app/javascript/customer.js", "./app/assets/stylesheets/customer.scss"]
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
      },
      {
        test: /\.(scss|sass|css)$/,
        use: [
          MiniCssExtractPlugin.loader,
          {
            loader: 'css-loader',
            options: {
              sourceMap: mode === 'development'
            }
          },
          {
            loader: 'sass-loader',
            options: {
              sourceMap: mode === 'development',
              sassOptions: {
                includePaths: [
                  path.resolve(__dirname, '..', '..', 'app/assets/stylesheets')
                ]
              }
            }
          }
        ]
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
    }),
    // Rails 8 CSS extraction for pack-based architecture
    new MiniCssExtractPlugin({
      filename: "[name].css",
      chunkFilename: "[id].css"
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
