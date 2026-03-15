import React from "react";
export function Input({
  label,
  error,
  className = "",
  id,
  prefix,
  ...props
}: any) {
  return (
    <div className="w-full space-y-1.5">
      {label && (
        <label
          htmlFor={id}
          className="text-[10px] font-medium uppercase tracking-[0.15em] leading-none text-primary/70 peer-disabled:cursor-not-allowed peer-disabled:opacity-70 ml-1"
        >
          {label}
        </label>
      )}
      <div className="relative">
        {prefix && (
          <span className="absolute left-4 top-2.5 text-muted-foreground text-[12.5px] font-medium">
            {prefix}
          </span>
        )}
        <input
          id={id}
          className={`flex h-10 w-full rounded-xl border border-border bg-background px-4 py-2 text-[12.5px] font-medium text-foreground placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-primary/40 disabled:cursor-not-allowed disabled:opacity-50 
          ${prefix ? "pl-8" : ""}
          ${error ? "border-rose-500/50 ring-rose-500/20" : ""}
          ${className}`}
          {...props}
          suppressHydrationWarning
        />
      </div>
      {error && (
        <p className="text-[9px] font-medium text-rose-400 uppercase tracking-widest ml-1">
          {error}
        </p>
      )}
    </div>
  );
}