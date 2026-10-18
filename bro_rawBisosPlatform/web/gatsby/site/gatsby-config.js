/**
 * platform.here --- the capabilities of this Raw-BISOS platform (rawBisosCBMs).
 *
 * See: https://www.gatsbyjs.com/docs/reference/config-files/gatsby-config/
 */

/**
 * @type {import('gatsby').GatsbyConfig}
 */
module.exports = {
  siteMetadata: {
    title: `platform.here`,
    description: `The capabilities (CBMs) of this Raw-BISOS platform, with links to their .here sites.`,
    author: `Mohsen Banan`,
    siteUrl: `http://platform.here`,
  },
  plugins: [
    `gatsby-plugin-postcss`,
    `gatsby-plugin-image`,
    {
      resolve: `gatsby-source-filesystem`,
      options: {
        name: `images`,
        path: `${__dirname}/src/images`,
      },
    },
    `gatsby-transformer-sharp`,
    `gatsby-plugin-sharp`,
    {
      resolve: `gatsby-plugin-manifest`,
      options: {
        name: `platform.here`,
        short_name: `platform`,
        start_url: `/`,
        background_color: `#001a4d`,
        display: `minimal-ui`,
        icon: `src/images/gatsby-icon.png`, // This path is relative to the root of the site.
      },
    },
  ],
}
