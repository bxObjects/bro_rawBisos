import * as React from "react"
import { Link } from "gatsby"

import Layout from "../components/Layout"
import Seo from "../components/seo"

const NotFoundPage = () => (
  <Layout>
    <h1>Page not found</h1>
    <p>Sorry, the page you're looking for doesn't exist.</p>
    <Link to="/">Go home</Link>
  </Layout>
)

export const Head = () => <Seo title="404: Not Found" />

export default NotFoundPage
