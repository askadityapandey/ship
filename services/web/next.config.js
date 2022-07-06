const withFonts = require('next-fonts');

module.exports = withFonts({
  webpack(config) {
    config.module.rules.push({
      test: /\.svg$/,
      use: ['@svgr/webpack'],
    });

    return config;
  },
  trailingSlash: true,
  pageExtensions: ['page.jsx', 'api.js'],
  reactStrictMode: true,
  eslint: {
    ignoreDuringBuilds: true,
  },
});
