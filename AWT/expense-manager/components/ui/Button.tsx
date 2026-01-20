import React from 'react';

export function Button({ 
  children, 
  className = '', 
  variant = 'primary', 
  size = 'md', 
  fullWidth = false, 
  ...props 
}: any) {
  
  // Base style
  let classes = 'inline-flex items-center justify-center rounded-md font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 shadow-sm ';

  // Variant styles - mapped to our new CSS variables
  if (variant === 'primary') classes += 'bg-primary text-primary-foreground hover:bg-primary/90 ';
  if (variant === 'secondary') classes += 'bg-secondary text-secondary-foreground hover:bg-secondary/80 ';
  if (variant === 'ghost') classes += 'bg-transparent text-accent-foreground hover:bg-accent hover:text-accent-foreground shadow-none ';
  if (variant === 'danger') classes += 'bg-destructive text-destructive-foreground hover:bg-destructive/90 ';
  if (variant === 'outline') classes += 'border border-input bg-background hover:bg-accent hover:text-accent-foreground '; // Added outline variant

  // Size styles
  if (size === 'sm') classes += 'h-8 px-3 text-xs ';
  if (size === 'md') classes += 'h-9 px-4 py-2 text-sm ';
  if (size === 'lg') classes += 'h-10 px-8 text-base ';
  if (size === 'icon') classes += 'h-9 w-9 p-0 ';

  // Full width
  if (fullWidth) classes += 'w-full ';

  // Custom class
  if (className) classes += className;

  return (
    <button className={classes.trim()} {...props} suppressHydrationWarning>
      {children}
    </button>
  );
}
