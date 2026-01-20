"use client";

import Link from 'next/link';
import { useTheme } from 'next-themes';
import { Sun, Moon } from 'lucide-react';
import { useEffect, useState } from 'react';

export function Sidebar({ role = 'normal' }: any) {
  
  // Role is now passed via props
  const userRole = role; 
  const { theme, setTheme } = useTheme();
  const [mounted, setMounted] = useState(false);

  // Avoid hydration mismatch
  useEffect(() => {
    setMounted(true);
  }, []);

  // Common links for everyone
  const commonLinks = [
    { name: 'Dashboard', href: '/dashboard' },
    { name: 'Expenses', href: '/expenses' },
    { name: 'Incomes', href: '/incomes' },
  ];

  // Admin only links
  const adminLinks = [
    { name: 'Manage Users', href: '/users' },
    { name: 'System Settings', href: '/settings' },
  ];

  // Normal user links (if specific ones exist)
  const normalLinks = [
    { name: 'My Profile', href: '/profile' },
  ];

  let linksToShow = commonLinks;

  if (userRole === 'admin') {
    linksToShow = [...commonLinks, ...adminLinks];
  } else {
    linksToShow = [...commonLinks, ...normalLinks];
  }

  return (
    <aside className="w-64 bg-sidebar border-r border-sidebar-border min-h-screen hidden md:flex flex-col text-sidebar-foreground">
      
      {/* Sidebar Header */}
      <div className="flex-shrink-0 flex items-center justify-center h-16 border-b border-sidebar-border">
        <span className="text-xl font-bold text-sidebar-primary">ExpenseManager</span>
      </div>
      
      {/* User Info Mock */}
      <div className="px-4 py-4 border-b border-sidebar-border bg-sidebar-accent/10">
        <p className="text-sm font-medium text-sidebar-foreground">Current User</p>
        <p className="text-xs text-muted-foreground capitalize">{userRole}</p>
      </div>

      {/* Navigation List */}
      <nav className="flex-1 px-4 py-6 space-y-1">
        {linksToShow.map((link) => (
          <Link
            key={link.name}
            href={link.href}
            className="group flex items-center px-2 py-2 text-sm font-medium rounded-md text-muted-foreground hover:bg-sidebar-accent hover:text-sidebar-accent-foreground transition-colors"
          >
            {/* Simple square for icon */}
            <span className="mr-3 h-5 w-5 bg-sidebar-accent rounded-sm" /> 
            {link.name}
          </Link>
        ))}
      </nav>

      {/* Footer Actions */}
      <div className="p-4 border-t border-sidebar-border space-y-2">
        {mounted && (
          <button
            onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')}
            className="group flex w-full items-center px-2 py-2 text-sm font-medium rounded-md text-muted-foreground hover:bg-sidebar-accent hover:text-sidebar-accent-foreground transition-colors"
          >
            {theme === 'dark' ? (
              <Sun className="mr-3 h-5 w-5" />
            ) : (
              <Moon className="mr-3 h-5 w-5" />
            )}
            {theme === 'dark' ? 'Light Mode' : 'Dark Mode'}
          </button>
        )}

        <Link href="/logout" className="group flex items-center px-2 py-2 text-sm font-medium rounded-md text-destructive hover:bg-destructive/10 hover:text-destructive">
          <span className="mr-3 h-5 w-5 bg-destructive/20 rounded-sm" />
          Logout
        </Link>
      </div>

    </aside>
  );
}
