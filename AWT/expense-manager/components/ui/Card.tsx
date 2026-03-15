import React from "react";
export function Card({ children, className = "", title, subtitle }: any) {
  return (
    <div
      className={`rounded-2xl border border-border bg-card text-card-foreground shadow-xl hover:shadow-primary/5 ${className}`}
    >
      {title && (
        <div className="flex flex-col space-y-1 p-5 border-b border-border mb-1 bg-card rounded-t-2xl">
          <h3 className="text-[15px] font-semibold tracking-tight text-foreground">
            {title}
          </h3>
          {subtitle && (
            <p className="text-[10px] text-primary font-medium uppercase tracking-[0.1em] opacity-60">
              {subtitle}
            </p>
          )}
        </div>
      )}
      <div className="p-5">{children}</div>
    </div>
  );
}