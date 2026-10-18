import * as React from "react"

/**
 * EmbeddedContent Component
 * 
 * Flexible component for embedding external content (iframes, internal services, etc.)
 * 
 * Props:
 * - url: string - The URL to embed
 * - title: string - Accessible title for the iframe
 * - aspectRatio: string - "16:9", "4:3", "1:1", or "auto" (default: "16:9")
 * - minHeight: string - Minimum height when aspectRatio is "auto" (default: "600px")
 * - border: boolean - Show border around iframe (default: true)
 * - sandbox: string - iframe sandbox attributes (default: allow-same-origin allow-scripts)
 * - allowFullscreen: boolean - Allow fullscreen mode (default: false)
 * - loading: "lazy" | "eager" - iframe loading strategy (default: "lazy")
 */
export default function EmbeddedContent({
  url,
  title = "Embedded Content",
  aspectRatio = "16:9",
  minHeight = "600px",
  border = true,
  sandbox = "allow-same-origin allow-scripts allow-popups allow-forms",
  allowFullscreen = false,
  loading = "lazy",
  showLoadingMessage = true,
}) {
  const [isLoading, setIsLoading] = React.useState(true)
  const [hasError, setHasError] = React.useState(false)

  // Calculate padding-bottom for aspect ratio
  const getPaddingBottom = () => {
    const ratios = {
      "16:9": "56.25%",
      "4:3": "75%",
      "1:1": "100%",
      "auto": "0",
    }
    return ratios[aspectRatio] || "56.25%"
  }

  const paddingBottom = getPaddingBottom()

  const containerStyle =
    aspectRatio === "auto"
      ? {
          width: "100%",
          minHeight: minHeight,
          marginTop: "1rem",
          marginBottom: "1rem",
        }
      : {
          position: "relative",
          width: "100%",
          paddingBottom: paddingBottom,
          height: 0,
          overflow: "hidden",
          marginTop: "1rem",
          marginBottom: "1rem",
        }

  const iframeStyle =
    aspectRatio === "auto"
      ? {
          width: "100%",
          height: "100%",
          border: border ? "1px solid #d1d5db" : "none",
          borderRadius: "4px",
        }
      : {
          position: "absolute",
          top: 0,
          left: 0,
          width: "100%",
          height: "100%",
          border: border ? "1px solid #d1d5db" : "none",
          borderRadius: "4px",
        }

  return (
    <div style={containerStyle}>
      {isLoading && showLoadingMessage && (
        <div
          style={{
            position: "absolute",
            top: "50%",
            left: "50%",
            transform: "translate(-50%, -50%)",
            textAlign: "center",
            color: "#666",
            zIndex: 1,
            fontSize: "0.9rem",
          }}
        >
          Loading content...
        </div>
      )}

      {hasError && (
        <div
          style={{
            width: "100%",
            padding: "2rem",
            backgroundColor: "#fee2e2",
            border: "1px solid #fca5a5",
            borderRadius: "4px",
            color: "#991b1b",
            textAlign: "center",
          }}
        >
          <p style={{ margin: "0 0 0.5rem 0" }}>
            <strong>Unable to load content</strong>
          </p>
          <p style={{ margin: 0, fontSize: "0.9rem" }}>
            The embedded content could not be loaded. This may be due to:
          </p>
          <ul
            style={{
              margin: "0.5rem 0 0 0",
              paddingLeft: "1.5rem",
              fontSize: "0.9rem",
            }}
          >
            <li>CORS restrictions</li>
            <li>The URL being unavailable</li>
            <li>Network connectivity issues</li>
          </ul>
          <p style={{ margin: "0.5rem 0 0 0", fontSize: "0.85rem" }}>
            <a
              href={url}
              target="_blank"
              rel="noopener noreferrer"
              style={{ color: "inherit" }}
            >
              Open content in new window →
            </a>
          </p>
        </div>
      )}

      {!hasError && (
        <iframe
          src={url}
          title={title}
          style={iframeStyle}
          sandbox={sandbox}
          allowFullScreen={allowFullscreen}
          loading={loading}
          onLoad={() => setIsLoading(false)}
          onError={() => {
            setIsLoading(false)
            setHasError(true)
          }}
        />
      )}
    </div>
  )
}
