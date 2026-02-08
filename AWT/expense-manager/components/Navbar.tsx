import Link from 'next/link';
import { Button } from './ui/Button';

export function Navbar() {
  return (
    <nav className="sticky top-0 z-50 w-full border-b border-border/40 bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex h-16 items-center justify-between">
          
          <div className="flex items-center gap-2">
            {/* Logo Icon Placeholder (Optional) */}
            <div className="h-8 w-8 rounded-lg bg-primary text-primary-foreground flex items-center justify-center font-bold text-lg">
              E
            </div>
            <Link href="/" className="text-xl font-bold tracking-tight text-foreground">
              Expen<span className="text-primary/70">Track</span>
            </Link>
          </div>

          <div className="hidden md:flex md:items-center md:space-x-6">
            <Link href="/" className="text-sm font-medium text-muted-foreground transition-colors hover:text-primary">
              Home
            </Link>
            <Link href="/about" className="text-sm font-medium text-muted-foreground transition-colors hover:text-primary">
              About
            </Link>
            
            <div className="flex items-center space-x-3 ml-4">
              <Link href="/login">
                <Button variant="ghost" size="sm" className="font-semibold">Log in</Button>
              </Link>
              <Link href="/register">
                <Button size="sm" className="shadow-sm">Sign up</Button>
              </Link>
            </div>
          </div>

          {/* Mobile menu trigger placeholder */}
          <div className="flex items-center md:hidden">
             <Button variant="ghost" size="sm">Menu</Button>
          </div>

        </div>
      </div>
    </nav>
  );
}
