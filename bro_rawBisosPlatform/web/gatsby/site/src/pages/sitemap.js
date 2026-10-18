import * as React from "react"
import Layout from "../components/Layout"
import SitemapComponent from "../components/SitemapComponent"
import Seo from "../components/seo"

const SitemapPage = () => (
  <Layout>
    <SitemapComponent />
  </Layout>
)

export const Head = () => <Seo title="Sitemap" />

export default SitemapPage
