import React from 'react';

export function Input({
  label,
  error,
  className = '',
  id,
  ...props
}: any) {
  return (
    <div className="w-full space-y-1.5">
      {label && (
        <label htmlFor={id} className="text-[10px] font-bold uppercase tracking-[0.15em] leading-none text-primary/70 peer-disabled:cursor-not-allowed peer-disabled:opacity-70 ml-1">
          {label}
        </label>
      )}
      <input
        id={id}
        className={`flex h-10 w-full rounded-xl border border-border bg-secondary/40 px-4 py-2 text-[12.5px] font-medium text-foreground placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-primary/40 disabled:cursor-not-allowed disabled:opacity-50 
        ${error ? 'border-rose-500/50 ring-rose-500/20' : ''}
        ${className}`}
        {...props}
        suppressHydrationWarning
      />
      {error && <p className="text-[9px] font-bold text-rose-400 uppercase tracking-widest ml-1">{error}</p>}
    </div>
  );
}
