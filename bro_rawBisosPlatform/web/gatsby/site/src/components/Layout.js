import * as React from "react"
import { useLocation } from "@reach/router"
import Header from './Header'
import Sidebar from './Sidebar'
import Footer from './Footer'
import SiblingTabs from './SiblingTabs'
import HamburgerMenu from './HamburgerMenu'
import MobileOverlay from './MobileOverlay'

// Normalize path for comparison (remove trailing slash)
function normalizePath(path) {
  return path === "/" ? "/" : path.replace(/\/$/, "")
}

export default function Layout({ 
  children, 
  showHeader = true, 
  showSidebar = true, 
  showFooter = true 
}) {
  const location = useLocation()
  const currentPath = normalizePath(location.pathname)
  const [sidebarOpen, setSidebarOpen] = React.useState(false)

  // Close sidebar when route changes
  React.useEffect(() => {
    setSidebarOpen(false)
  }, [location.pathname])

  // Lock/unlock body scroll when sidebar opens/closes
  React.useEffect(() => {
    if (sidebarOpen) {
      // Calculate scrollbar width to prevent layout shift
      const scrollbarWidth = window.innerWidth - document.documentElement.clientWidth
      
      // Disable scrolling
      document.documentElement.style.overflow = 'hidden'
      document.body.style.overflow = 'hidden'
      document.body.style.paddingRight = `${scrollbarWidth}px`
    } else {
      // Re-enable scrolling
      document.documentElement.style.overflow = 'auto'
      document.body.style.overflow = 'auto'
      document.body.style.paddingRight = '0px'
    }

    // Cleanup on unmount
    return () => {
      document.documentElement.style.overflow = 'auto'
      document.body.style.overflow = 'auto'
      document.body.style.paddingRight = '0px'
    }
  }, [sidebarOpen])

  return (
    <div className="flex flex-col min-h-screen bg-slate-100">
      {/* Hamburger Menu Button */}
      <HamburgerMenu 
        isOpen={sidebarOpen} 
        onClick={() => setSidebarOpen(!sidebarOpen)} 
      />

      {/* Mobile Overlay */}
      <MobileOverlay 
        isOpen={sidebarOpen} 
        onClick={() => setSidebarOpen(false)} 
      />

      {/* Main Container */}
      <div className="flex flex-col min-h-screen max-w-6xl w-full mx-auto bg-white border-l-2 border-r-2 border-t-2 border-blue-900">
        
        {/* Header - Hidden when mobile sidebar is open */}
        {showHeader && !sidebarOpen && <Header />}

        {/* Sibling Tabs (shown when no sidebar) */}
        {!showSidebar && <SiblingTabs currentPath={currentPath} />}

        {/* Main Content Area - Hidden when mobile sidebar is open */}
        {!sidebarOpen && (
          <div style={{ display: 'flex', flex: 1, flexDirection: 'row' }}>
            
            {/* Sidebar - Hidden on mobile, visible on md and up */}
            {showSidebar && (
              <>
                {/* Desktop Sidebar - Always visible on desktop, hidden on mobile */}
                <aside className="hidden md:block desktop-sidebar bg-gray-100 border-r border-gray-300 overflow-y-auto flex-shrink-0" style={{ 
                  width: '256px',
                  minHeight: '100%',
                }}>
                  <div className="p-4">
                    <Sidebar />
                  </div>
                </aside>
              </>
            )}

            {/* Main Content */}
            <main style={{ flex: 1, padding: '1rem' }}>
              {children}
            </main>
          </div>
        )}

        {/* Mobile Sidebar - Overlay only when sidebar is open on small screens */}
        {sidebarOpen && (
          <div style={{
            position: 'fixed',
            left: 0,
            top: 0,
            height: '100vh',
            width: '100%',
            backgroundColor: '#f3f4f6',
            overflowY: 'auto',
            zIndex: 40,
            display: 'flex',
            flexDirection: 'column'
          }}>
            <div style={{ width: '256px', padding: '1rem', overflowY: 'auto', flex: 1 }}>
              <Sidebar />
            </div>
          </div>
        )}

        {/* Footer - Hidden when mobile sidebar is open */}
        {showFooter && !sidebarOpen && <Footer />}
      </div>
    </div>
  )
}