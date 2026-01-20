import React from 'react';

export function Input({
  label,
  error,
  className = '',
  id,
  ...props
}: any) {
  return (
    <div className="w-full space-y-2">
      {label && (
        <label htmlFor={id} className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
          {label}
        </label>
      )}
      <input
        id={id}
        className={`flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm text-foreground shadow-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50 
        ${error ? 'border-destructive ring-destructive' : ''}
        ${className}`}
        {...props}
        suppressHydrationWarning
      />
      {error && <p className="text-sm font-medium text-destructive">{error}</p>}
    </div>
  );
}
