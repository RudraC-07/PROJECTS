import React from 'react';

export function Card({ 
  children, 
  className = '', 
  title,
  subtitle
}: any) {
  return (
    <div className={`rounded-2xl border border-white/5 bg-white/5 backdrop-blur-md text-card-foreground shadow-xl hover:shadow-primary/5 transition-all duration-500 ${className}`}>
      {title && (
        <div className="flex flex-col space-y-1 p-5 border-b border-white/5 mb-1 bg-white/[0.01] rounded-t-2xl">
          <h3 className="text-[15px] font-bold tracking-tight text-foreground">
             {title}
          </h3>
          {subtitle && <p className="text-[10px] text-primary font-semibold uppercase tracking-[0.1em] opacity-60">{subtitle}</p>}
        </div>
      )}
      <div className="p-5">
        {children}
      </div>
    </div>
  );
}